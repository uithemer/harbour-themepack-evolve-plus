import QtQuick 2.0
import Sailfish.Silica 1.0
import uithemer.themescripts 1.0
import "../components"

Page
{
    id: firstpage
    focus: true
    ThemePack { id: themePack }


    Keys.onPressed: {
        handleKeyPressed(event);
    }

    function handleKeyPressed(event) {

        if (event.key === Qt.Key_Down) {
            flickable.flick(0, - firstpage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_Up) {
            flickable.flick(0, firstpage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_PageDown) {
            flickable.scrollToBottom();
            event.accepted = true;
        }

        if (event.key === Qt.Key_PageUp) {
            flickable.scrollToTop();
            event.accepted = true;
        }
    }

    BusyState { id: busyindicator; }

    Connections
    {
        function notify() {
            busyindicator.running = false;
        }

        target: themePack
        onIconsFetched: notify()
    }

    SilicaFlickable
    {
        id: flickable
        anchors.fill: parent
        anchors.bottomMargin: Theme.paddingLarge
        contentHeight: content.height
        enabled: !busyindicator.running
        opacity: busyindicator.running ? 0.0 : 1.0

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

           PageHeader { title: qsTr("Evolve Plus") }

            Item {
                height: appicon.height + Theme.paddingMedium
                width: parent.width

                Image { id: appicon; anchors.horizontalCenter: parent.horizontalCenter; source: "../../appinfo.png" }
            }

            LabelText {
                text: qsTr("Thank you for installing Evolve Plus!")
            }

            LabelText {
                text: qsTr("Released under the GNU GPLv3 license. Icons by <a href='https://twitter.com/wanmonstar'>WanMonstar</a> and <a href='https://twitter.com/Nfanliver'>Nfanliver</a>. Icons are released under the <a href='https://creativecommons.org/licenses/by-nc-sa/4.0/'>Creative Common BY-NC-SA 4.0</a> license.")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Sources")
                onClicked: Qt.openUrlExternally("https://fravaccaro.github.io/harbour-themepack-evolve-plus/")
            }

            SectionHeader { text: qsTr("Icon request") }

            LabelText {
                text: qsTr("From here you can request missing icons for your favorite apps.")
            }

            LabelText {
                text: qsTr("This will open your e-mail client, from which you can send me the name of the apps you would like to be included in this theme.")
             }

            LabelText {
                text: qsTr("By requesting new icons, you accept sending the name of the unthemed apps installed on your device, along with your e-mail address. This data will be used by me only for the intended purpose and NEVER disclosed to thirdy parties. Your app names and e-mail address will be deleted right after.")
             }

            LabelText {
                text: qsTr("If you plan to request icons, please consider to donate! It helps me staying motivated and maintaining the project.")
             }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Request icons")
                onClicked: {
                        busyindicator.running = true;
                        themePack.fetchIcons();
                }
            }

            SectionHeader { text: qsTr("Developers") }

              LabelText {
                  text: qsTr("If you want to create a theme compatible with UI Themer, please read the documentation.")
               }

              Button {
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: qsTr("Documentation")
                  onClicked: Qt.openUrlExternally("https://fravaccaro.github.io/themepacksupport-sailfishos/docs/getstarted.html")
              }

              SectionHeader { text: qsTr("Support") }

              LabelText {
                  text: qsTr("If you like my work and want to buy me a beer, feel free to do it!")
              }

              Button {
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: qsTr("Donate")
                  onClicked: Qt.openUrlExternally("https://www.paypal.me/fravaccaro")
              }

              SectionHeader { text: qsTr("Credits") }

              LabelText {
                  text: qsTr("Keyboard navigation based on the one on <a href='https://github.com/Wunderfitz/harbour-piepmatz'>Piepmatz</a> by Sebastian Wolf.")
               }

              SectionHeader { text: qsTr("Translations") }

              AboutLanguage { text: "Deutsch" }
              AboutTranslator { text: "Sailfishman" }
              Item { width: parent.width; height: Theme.paddingLarge }

              AboutLanguage { text: "Español" }
              AboutTranslator { text: "Rafael Morales" }
              Item { width: parent.width; height: Theme.paddingLarge }

              AboutLanguage { text: "Italiano" }
              AboutTranslator { text: "Francesco Vaccaro" }
              Item { width: parent.width; height: Theme.paddingLarge }

              AboutLanguage { text: "Slovenščina" }
              AboutTranslator { text: "Boštjan Štrumbelj" }
              Item { width: parent.width; height: Theme.paddingLarge }

              AboutLanguage { text: "Zhōngwén (Chinese)" }
              AboutTranslator { text: "rui kon" }
              Item { width: parent.width; height: Theme.paddingLarge }

              LabelText {
                  text: qsTr("Request a new language or contribute to existing languages on the Transifex project page.")
              }

              Button {
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: qsTr("Transifex")
                  onClicked: Qt.openUrlExternally("https://www.transifex.com/fravaccaro/evolve-plus")
              }

        }

        VerticalScrollDecorator { }
    }
}
