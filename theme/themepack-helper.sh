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

export_svg() {
    local input="$1"
    local width="$2"
    local height="$3"
    local output="$4"

    if inkscape --version 2>/dev/null | grep -q '^Inkscape 0\.'; then
        inkscape -f "$input" -w "$width" -h "$height" -e "$output"
    else
        inkscape "$input" -w "$width" -h "$height" -o "$output"
    fi
}

# Resize Jolla stock icons
if [ "$(ls ./jolla/scalable/icons 2>/dev/null)" ]; then

    ls ./jolla/scalable/icons/*.svg | while read -r file
        do
            filename=$(basename "$file")
            destFile="${filename%.svg}.png"
            export_svg "$file" 86 86 "./jolla/z1.0/icons/$destFile"
            export_svg "$file" 108 108 "./jolla/z1.25/icons/$destFile"
            export_svg "$file" 129 129 "./jolla/z1.5/icons/$destFile"
            export_svg "$file" 129 129 "./jolla/z1.5-large/icons/$destFile"
            export_svg "$file" 151 151 "./jolla/z1.75/icons/$destFile"
            export_svg "$file" 172 172 "./jolla/z2.0/icons/$destFile"
        done
fi

# Resize native apps icons
if [ "$(ls ./native/scalable/apps 2>/dev/null)" ]; then
    ls ./native/scalable/apps/*.svg | while read -r file
        do
            filename=$(basename "$file")
            destFile="${filename%.svg}.png"
            export_svg "$file" 86 86 "./native/86x86/apps/$destFile"
            export_svg "$file" 108 108 "./native/108x108/apps/$destFile"
            export_svg "$file" 128 128 "./native/128x128/apps/$destFile"
            export_svg "$file" 256 256 "./native/256x256/apps/$destFile"
        done
fi

# Resize Android icons
if [ "$(ls ./apk/scalable 2>/dev/null)" ]; then
    ls ./apk/scalable/*.svg | while read -r file
        do
            filename=$(basename "$file")
            destFile="${filename%.svg}.png"
            export_svg "$file" 86 86 "./apk/86x86/$destFile"
            export_svg "$file" 128 128 "./apk/128x128/$destFile"
        done
fi

# Resize DynCal icons
if [ "$(ls ./dyncal/scalable/ 2>/dev/null)" ]; then
    ls ./dyncal/scalable/*.svg | while read -r file
        do
            filename=$(basename "$file")
            destFile="${filename%.svg}.png"
            export_svg "$file" 86 86 "./dyncal/86x86/$destFile"
            export_svg "$file" 256 256 "./dyncal/256x256/$destFile"
        done
fi

# Resize DynClock icons
if [ "$(ls ./dynclock/scalable/ 2>/dev/null)" ]; then
    ls ./dynclock/scalable/*.svg | while read -r file
        do
            filename=$(basename "$file")
            destFile="${filename%.svg}.png"
            export_svg "$file" 86 86 "./dynclock/86x86/$destFile"
            export_svg "$file" 256 256 "./dynclock/256x256/$destFile"
        done
fi

# Resize overlays
if [ "$(ls ./overlay/ 2>/dev/null)" ]; then
    ls ./overlay/*.svg | while read -r file
        do
            filename=$(basename "$file")
            destFile="${filename%.svg}.png"
            export_svg "$file" 512 512 "./overlay/$destFile"
        done
fi
exit 0
