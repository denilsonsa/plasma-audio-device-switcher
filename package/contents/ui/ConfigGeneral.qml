/*
    Copyright 2017 Andreas Krutzler <andreas.krutzler@gmx.net>

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation; either version 2 of
    the License or (at your option) version 3 or any later version
    accepted by the membership of KDE e.V. (or its successor approved
    by the membership of KDE e.V.), which shall act as a proxy
    defined in Section 14 of version 3 of the license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kcmutils as KCM

import org.kde.plasma.private.volume 0.1

KCM.SimpleKCM {
    id: page
    property alias cfg_useVerticalLayout: useVerticalLayout.checked
    property alias cfg_sourceInsteadofSink: sourceInsteadofSink.checked
    property int cfg_labeling: 0
    property int cfg_naming: 0
    property string cfg_defaultIconName: defaultIconName

    readonly property var sinkModel: SinkModel {} // used for description examples, if possible

    title: i18n("General")
    Layout.fillWidth: true

    Kirigami.FormLayout {

        ColumnLayout {
            Kirigami.FormData.label: i18n("Controls:")
            Kirigami.FormData.buddyFor: useVerticalLayout

            CheckBox {
                id: useVerticalLayout
                text: i18n("Use vertical layout")
            }
            CheckBox {
                id: sourceInsteadofSink
                text: i18n("Control source instead of sink")
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        ColumnLayout {
            id: labeling
            Kirigami.FormData.label: i18n("Labeling:")
            Kirigami.FormData.buddyFor: labelingRepeater

            Repeater {
                id: labelingRepeater
                model: [
                    i18n("Show icon with description"),
                    i18n("Show description only"),
                    i18n("Show icon only")
                ]
                RadioButton {
                    text: modelData
                    checked: index === cfg_labeling
                    onClicked: {
                        cfg_labeling = index
                    }
                }
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        ColumnLayout {
            id: naming
            Kirigami.FormData.label: i18n("Description:")
            Kirigami.FormData.buddyFor: namingRepeater

            Repeater {
                id: namingRepeater
                model: generateDescriptionModel()
                RadioButton {
                    text: modelData
                    checked: index === cfg_naming
                    onClicked: {
                        cfg_naming = index
                    }
                }
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        ComboBox {
            id: defaultIconName
            Kirigami.FormData.label: i18n("Default icon:")
            Layout.fillWidth: true
            Layout.maximumWidth: Kirigami.Units.gridUnit * 8

            textRole: "text"
            valueRole: "value"

            model: ListModel {
                id: cbItems
                ListElement { text: "Speakers"  ; value: "audio-speakers-symbolic" }
                ListElement { text: "Headphones"; value: "audio-headphones" }
                ListElement { text: "Headset"   ; value: "audio-headset" }
                ListElement { text: "Microphone"; value: "audio-input-microphone-symbolic" }
                ListElement { text: "Audio card"; value: "audio-card" }
            }

            delegate: ItemDelegate {
                id: delegate
                required property var model
                required property int index

                text: delegate.model.text
                icon.name: delegate.model.value
                width: defaultIconName.width
                highlighted: defaultIconName.highlightedIndex === index
            }

            contentItem: Item {
                Kirigami.Icon {
                    id: icon
                    source: defaultIconName.currentValue
                    height: parent.height
                }
                Label {
                    text: defaultIconName.currentText
                    anchors.left: icon.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            displayText: ""; // Otherwise, the contentItem's label overlaps the background's display of this displayText.

            Component.onCompleted: currentIndex = indexOfValue(cfg_defaultIconName)
            onActivated: cfg_defaultIconName = currentValue
        }
    }


    function generateDescriptionModel() {
        const defaultSink = sinkModel?.defaultSink;
        const firstPort = defaultSink?.ports.length > 0 ? defaultSink.ports[0] : null;
        
        function withExample(label, example) {
            return example? (label + " (e.g., \"" + example + "\")") : label;
        }

        return [
            withExample(i18n("Device description"), defaultSink?.description),
            withExample(i18n("Port description"), firstPort?.description),
            withExample(i18n("Node nickname"), defaultSink?.properties["node.nick"]),
        ];
    }

}