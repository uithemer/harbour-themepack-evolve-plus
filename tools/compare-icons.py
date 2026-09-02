#!/usr/bin/env python3
"""Compare two exported theme trees pixel by pixel.

Inkscape's PNG encoder is not reproducible across builds, so the files are
never byte-identical.  Only the decoded pixels are meaningful, which is exactly
what has to stay stable: a renderer that draws these icons differently is the
bug this guards against.

Colours are compared premultiplied by alpha.  RGB is undefined wherever alpha
is zero, and renderers disagree freely there -- one writes opaque black under a
transparent pixel, another writes white -- which is invisible but would
otherwise swamp the comparison.

Usage: compare-icons.py <committed-theme-dir> <freshly-exported-theme-dir>
"""

import os
import sys

import numpy as np
from PIL import Image

# Out of a possible 4*255. Absorbs a rounding step on an antialiased edge,
# while a shape that changed colour or went missing is orders of magnitude out.
TOLERANCE = 30


def premultiplied(path):
    px = np.asarray(Image.open(path).convert('RGBA'), dtype=np.float64)
    alpha = px[..., 3:4] / 255.0
    return np.concatenate([px[..., :3] * alpha, px[..., 3:4]], axis=-1)


def differing_pixels(a_path, b_path):
    a, b = premultiplied(a_path), premultiplied(b_path)
    if a.shape != b.shape:
        return None
    return int((np.abs(a - b).sum(axis=-1) > TOLERANCE).sum())


def pngs(tree):
    return {os.path.relpath(os.path.join(root, name), tree)
            for root, _, files in os.walk(tree)
            for name in files if name.endswith('.png')}


def main(committed, exported):
    have, fresh = pngs(committed), pngs(exported)
    failures = []

    for rel in sorted(have & fresh):
        n = differing_pixels(os.path.join(committed, rel), os.path.join(exported, rel))
        if n is None:
            failures.append(f'{rel}: size mismatch')
        elif n:
            failures.append(f'{rel}: {n} pixels differ')

    # An SVG added without running the export script: the icon has a source in
    # the repo but no PNG, and the PNGs are what actually ships.
    unexported = sorted(fresh - have)
    # A PNG the export no longer produces, i.e. its SVG source is gone.
    orphaned = sorted(have - fresh)

    for rel in unexported:
        print(f'never exported (SVG has no committed PNG): {rel}')
    for rel in orphaned:
        print(f'no longer exported (SVG source gone?): {rel}')
    for line in failures:
        print(line)

    broken = len(failures) + len(unexported) + len(orphaned)
    if broken:
        print(f'\n{broken} of {len(have | fresh)} icons do not match their SVG source.')
        print('Re-export locally with: cd theme && ./themepack-helper.sh')
        return 1

    print(f'{len(have)} icons match their SVG source.')
    return 0


if __name__ == '__main__':
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1], sys.argv[2]))
