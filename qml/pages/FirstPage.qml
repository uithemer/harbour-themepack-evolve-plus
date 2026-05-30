import QtQuick 2.0
import Sailfish.Silica 1.0
import uithemer.themescripts 1.0
import "../components"

Page
{
    id: firstpage
    property var settings
    property bool donationAcknowledged: false

    ThemePack { id: themePack }

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
        opacity: busyindicator.running ? 0.3 : 1.0

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader { title: settings.appName }

            Item {
                height: appicon.height + Theme.paddingMedium
                width: parent.width

                Image { id: appicon; anchors.horizontalCenter: parent.horizontalCenter; source: settings.appIcon }
            }

            LabelText {
                text: qsTr("Thank you for installing %1!").arg(settings.appName)
            }

            LabelText {
                text: settings.iconAttributionHtml
            }

            LabelSpacer { }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Sources")
                onClicked: Qt.openUrlExternally(settings.sourcesUrl)
            }

            SectionHeader { text: qsTr("Icon request") }

            LabelText {
                text: qsTr("From here you can request missing icons for your favorite apps.")
            }

            LabelText {
                text: qsTr("This will open your e-mail client, from which you can send the maintainer the name of the apps you would like to be included in this theme.")
            }

            LabelText {
                text: qsTr("By requesting new icons, you accept sending the name of the unthemed apps installed on your device, along with your e-mail address. This data will be used only for the intended purpose and NEVER disclosed to third parties. Your app names and e-mail address will be deleted right after.")
            }

            LabelText {
                text: qsTr("If you plan to request icons, please consider donating! It helps support development and maintenance of the project.")
            }

            LabelSpacer { }

            Button {
                id: donate
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Donate")
                onClicked: {
                    Qt.openUrlExternally(settings.donateUrl)
                    donationAcknowledged = true
                    skipDonateSwitch.enabled = false
                }
            }

            IconTextSwitch {
                id: skipDonateSwitch
                automaticCheck: true
                text: qsTr("I don't care donating")
                onClicked: {
                    if (checked) {
                        donate.enabled = false
                        donationAcknowledged = true
                    } else {
                        donate.enabled = true
                        donationAcknowledged = false
                    }
                }
            }

            LabelSpacer { }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: donationAcknowledged && !busyindicator.running
                text: qsTr("Request icons")
                onClicked: {
                    busyindicator.running = true
                    themePack.fetchIcons(settings.packInstallPath, settings.iconRequestEmail, settings.iconRequestSubject)
                }
            }

            SectionHeader { text: qsTr("Developers") }

            LabelText {
                text: qsTr("If you want to create a theme compatible with UI Themer, please read the documentation.")
            }

            LabelSpacer { }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Documentation")
                onClicked: Qt.openUrlExternally(settings.docsUrl)
            }

            SectionHeader { text: qsTr("Translations") }

            Repeater {
                model: settings.translators
                DetailItem {
                    label: modelData.language
                    value: modelData.name
                }
            }

            LabelText {
                text: qsTr("Request a new language or contribute to existing languages on the Transifex project page.")
            }

            LabelSpacer { }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Transifex")
                onClicked: Qt.openUrlExternally(settings.transifexUrl)
            }

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }

        }

        VerticalScrollDecorator { }
    }
}
