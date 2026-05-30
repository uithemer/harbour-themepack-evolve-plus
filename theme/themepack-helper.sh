#!/bin/bash
#
#    Theme pack support for Sailfish OS - Enables theme pack support in Sailfish OS.
#    Copyright (C) 2015-2016  fravaccaro fravaccaro90@gmail.com - Initial release
#    Copyright (C) 2016  dfstorm dfstorm@riseup.net - Change from ImageMagik to Inkscape
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Usage
# Place some icons in scalable folders and launch this script from the theme folder.

shopt -s nullglob

cd "$(dirname "$0")" || exit 1

INKSCAPE_LEGACY=0
if inkscape --version 2>/dev/null | grep -q '^Inkscape 0\.'; then
    INKSCAPE_LEGACY=1
fi
echo "Using Inkscape $(inkscape --version 2>/dev/null | head -1)" >&2

export_svg_legacy() {
    local input="$1"
    local width="$2"
    local height="$3"
    local output="$4"

    mkdir -p "$(dirname "$output")"
    echo "Exporting $input → $output" >&2
    inkscape -f "$input" -w "$width" -h "$height" -e "$output"
}

# Usage: export_svg_sizes INPUT W H OUTPUT [W H OUTPUT ...]
export_svg_sizes() {
    local input="$1"
    shift

    if [ "$INKSCAPE_LEGACY" -eq 1 ]; then
        while [ $# -ge 3 ]; do
            export_svg_legacy "$input" "$1" "$2" "$3"
            shift 3
        done
        return
    fi

    local actions="export-type:png"
    while [ $# -ge 3 ]; do
        local w=$1
        local h=$2
        local out=$3
        local out_abs
        mkdir -p "$(dirname "$out")"
        out_abs="$(realpath -m "$out")"
        echo "Exporting $input → $out" >&2
        actions="${actions};export-filename:${out_abs};export-width:${w};export-height:${h};export-do"
        shift 3
    done
    inkscape "$input" --actions="$actions"
}

# Resize Jolla stock icons
if [ -d ./jolla/scalable/icons ] && [ "$(ls -A ./jolla/scalable/icons 2>/dev/null)" ]; then
    echo "==> Jolla icons" >&2
    for file in ./jolla/scalable/icons/*.svg; do
        filename=$(basename "$file")
        destFile="${filename%.svg}.png"
        export_svg_sizes "$file" \
            86  86  "./jolla/z1.0/icons/$destFile" \
            108 108 "./jolla/z1.25/icons/$destFile" \
            129 129 "./jolla/z1.5/icons/$destFile" \
            129 129 "./jolla/z1.5-large/icons/$destFile" \
            151 151 "./jolla/z1.75/icons/$destFile" \
            172 172 "./jolla/z2.0/icons/$destFile"
    done
fi

# Resize native apps icons
if [ -d ./native/scalable/apps ] && [ "$(ls -A ./native/scalable/apps 2>/dev/null)" ]; then
    echo "==> Native app icons" >&2
    for file in ./native/scalable/apps/*.svg; do
        filename=$(basename "$file")
        destFile="${filename%.svg}.png"
        export_svg_sizes "$file" \
            86  86  "./native/86x86/apps/$destFile" \
            108 108 "./native/108x108/apps/$destFile" \
            128 128 "./native/128x128/apps/$destFile" \
            256 256 "./native/256x256/apps/$destFile"
    done
fi

# Resize Android icons
if [ -d ./apk/scalable ] && [ "$(ls -A ./apk/scalable 2>/dev/null)" ]; then
    echo "==> Android icons" >&2
    for file in ./apk/scalable/*.svg; do
        filename=$(basename "$file")
        destFile="${filename%.svg}.png"
        export_svg_sizes "$file" \
            86  86  "./apk/86x86/$destFile" \
            128 128 "./apk/128x128/$destFile"
    done
fi

# Resize DynCal icons
if [ -d ./dyncal/scalable ] && [ "$(ls -A ./dyncal/scalable 2>/dev/null)" ]; then
    echo "==> DynCal icons" >&2
    for file in ./dyncal/scalable/*.svg; do
        filename=$(basename "$file")
        destFile="${filename%.svg}.png"
        export_svg_sizes "$file" \
            86  86  "./dyncal/86x86/$destFile" \
            256 256 "./dyncal/256x256/$destFile"
    done
fi

# Resize DynClock icons
if [ -d ./dynclock/scalable ] && [ "$(ls -A ./dynclock/scalable 2>/dev/null)" ]; then
    echo "==> DynClock icons" >&2
    for file in ./dynclock/scalable/*.svg; do
        filename=$(basename "$file")
        destFile="${filename%.svg}.png"
        export_svg_sizes "$file" \
            86  86  "./dynclock/86x86/$destFile" \
            256 256 "./dynclock/256x256/$destFile"
    done
fi

# Resize overlays
if [ -d ./overlay ] && [ "$(ls -A ./overlay/*.svg 2>/dev/null)" ]; then
    echo "==> Overlays" >&2
    for file in ./overlay/*.svg; do
        filename=$(basename "$file")
        destFile="${filename%.svg}.png"
        export_svg_sizes "$file" \
            512 512 "./overlay/$destFile"
    done
fi

exit 0
