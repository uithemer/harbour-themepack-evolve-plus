#!/usr/bin/env python3
"""Normalise gradient coordinate systems in SVG files.

The icons were exported with gradient coordinates far outside the document
(x1/x2 = +/-6528) combined with a gradientTransform that scales them back down
by ~20-50x.  That is valid SVG, but it pushes the shape's coordinates in
pattern space beyond cairo's fixed point range, so cairo-based renderers clip
the filled area.

Rewriting p -> p/k with the linear part of the matrix multiplied by k is an
exact algebraic identity for any affine matrix, so this only changes the
numbers, never the rendered result.
"""

import math
import re
import sys

MATRIX_RE = re.compile(r'^\s*matrix\(([^)]*)\)\s*$')
GRAD_RE = re.compile(r'<(linear|radial)Gradient\b([^>]*)>')


def fmt(v):
    s = f'{v:.6f}'.rstrip('0').rstrip('.')
    return s if s not in ('', '-0') else '0'


def normalise_tag(kind, attrs):
    m = re.search(r'gradientTransform="([^"]*)"', attrs)
    if not m or 'userSpaceOnUse' not in attrs:
        return None
    mm = MATRIX_RE.match(m.group(1))
    if not mm:
        return None
    a, b, c, d, e, f = (float(x) for x in re.split(r'[,\s]+', mm.group(1).strip()))

    det = a * d - b * c
    if det == 0:
        return None
    scale = math.sqrt(abs(det))
    if 0.5 < scale < 2:
        return None

    coords = ['x1', 'y1', 'x2', 'y2'] if kind == 'linear' else ['cx', 'cy', 'r', 'fx', 'fy']
    out = attrs
    for name in coords:
        cm = re.search(rf'\b{name}="([^"]*)"', out)
        if not cm:
            continue
        if cm.group(1).strip().endswith('%'):
            return None
        out = out[:cm.start(1)] + fmt(float(cm.group(1)) * scale) + out[cm.end(1):]

    new = f'matrix({fmt(a / scale)},{fmt(b / scale)},{fmt(c / scale)},{fmt(d / scale)},{fmt(e)},{fmt(f)})'
    gm = re.search(r'gradientTransform="([^"]*)"', out)
    return out[:gm.start(1)] + new + out[gm.end(1):]


def process(text):
    pieces, last, count = [], 0, 0
    for m in GRAD_RE.finditer(text):
        new_attrs = normalise_tag(m.group(1), m.group(2))
        if new_attrs is None:
            continue
        pieces.append(text[last:m.start()])
        pieces.append(f'<{m.group(1)}Gradient{new_attrs}>')
        last = m.end()
        count += 1
    pieces.append(text[last:])
    return ''.join(pieces), count


if __name__ == '__main__':
    args = sys.argv[1:]
    check = '--check' in args
    paths = [a for a in args if a != '--check']

    total, offenders = 0, []
    for path in paths:
        with open(path, encoding='utf-8') as fh:
            src = fh.read()
        new, n = process(src)
        if not n:
            continue
        total += n
        if check:
            offenders.append(f'{path}: {n} gradients need normalising')
        else:
            with open(path, 'w', encoding='utf-8') as fh:
                fh.write(new)
            print(f'{path}: {n} gradients normalised')

    if check:
        if offenders:
            print('\n'.join(offenders))
            print(f'\n{total} gradients still use out-of-range coordinates.')
            print('Run: python3 tools/normalize-gradients.py $(find theme -name "*.svg")')
            sys.exit(1)
        print(f'{len(paths)} SVGs checked, all gradients normalised.')
    else:
        print(f'total: {total}')
