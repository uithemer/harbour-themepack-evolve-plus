import QtQuick 2.0

// Maintainer configuration — edit this file when forking the template.
//
// Also update separately (not in this file):
//   - harbour-themepack-evolve-plus.pro  (TARGET)
//   - rpm/harbour-themepack-evolve-plus.spec  (Summary, Packager, URL)
//   - harbour-themepack-evolve-plus.desktop  (Name=)
//   - README.md, _config.yml, theme/package
//   - README-companion.md  (draft; canonical docs at github.com/uithemer/harbour-themepack-companion)
//
// packInstallPath must match TARGET install path: /usr/share/<TARGET>

QtObject {
    readonly property string appName: "Evolve Plus"
    readonly property string appIcon: "../../appinfo.png"

    readonly property string iconAttributionHtml:
        "Released under the GNU GPLv3 license. Icons by " +
        "<a href='https://twitter.com/wanmonstar'>WanMonstar</a> and " +
        "<a href='https://twitter.com/Nfanliver'>Nfanliver</a>. Icons are released under the " +
        "<a href='https://creativecommons.org/licenses/by-nc-sa/4.0/'>Creative Common BY-NC-SA 4.0</a> license."

    readonly property string sourcesUrl: "https://uithemer.github.io/harbour-themepack-evolve-plus/"
    readonly property string docsUrl: "https://github.com/uithemer/harbour-themepack-companion"
    readonly property string donateUrl: "https://liberapay.com/fravaccaro"
    readonly property string transifexUrl: "https://explore.transifex.com/fravaccaro/evolve-plus/"

    readonly property var translators: [
        { language: "Deutsch", name: "Sailfishman" },
        { language: "Español", name: "Rafael Morales" },
        { language: "Italiano", name: "Francesco Vaccaro" },
        { language: "Nederlands", name: "Nathan Follens" },
        { language: "Neerlandais (Belgique)", name: "Nathan Follens" },
        { language: "русский (Russian)", name: "Oleh Ampilohov" },
        { language: "Slovenščina", name: "Boštjan Štrumbelj" },
        { language: "Zhōngwén (Chinese)", name: "rui kon" }
    ]

    readonly property string packInstallPath: "/usr/share/harbour-themepack-evolve-plus"
    readonly property string iconRequestEmail: "me@fravaccaro.com"
    readonly property string iconRequestSubject: "Icon request for Evolve Plus"
}
