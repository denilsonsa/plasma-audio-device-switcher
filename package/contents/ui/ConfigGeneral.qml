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
import QtQuick.Layouts 
import QtQuick.Controls 
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property int cfg_labeling: 0
    property alias cfg_usePortDescription: usePortDescription.checked

    property alias cfg_useVerticalLayout: useVerticalLayout.checked
    
    property alias cfg_sourceInsteadofSink: sourceInsteadofSink.checked

    property string cfg_defaultIconName:  defaultIconName

    Kirigami.FormLayout {
        Layout.fillWidth: true

        ColumnLayout {
            id: labeling
            Repeater {
                id: buttonRepeater
                model: [
                    i18n("Show icon with description"),
                    i18n("Show description only"),
                    i18n("Show icon only")
                ]
                RadioButton {
                    text: modelData
                    checked: index === cfg_labeling
                    autoExclusive: true
                    onClicked: {
                        cfg_labeling = index
                    }
                }
            }
        }

        CheckBox {
            id: usePortDescription
            text: i18n("Use the port description rather than the device description")
        }

        CheckBox {
            id: useVerticalLayout
            text: i18n("Use vertical layout")
        }

        CheckBox {
            id: sourceInsteadofSink
            text: i18n("Control source instead of sink")
        }

        Label {
            text: i18n("Default icon")
            topPadding: 25
        }
        ComboBox {
            textRole: "text"
            valueRole: "value"

            id: defaultIconName
            model: ListModel {
                    id: cbItems
                    ListElement { text: "Speakers"  ; value: "audio-speakers-symbolic" }
                    ListElement { text: "Headphones"; value: "audio-headphones" }
                    ListElement { text: "Headset"   ; value: "audio-headset" }
                    ListElement { text: "Microphone"; value: "audio-input-microphone-symbolic" }
                    ListElement { text: "Audio card"; value: "audio-card" }
            }
            Component.onCompleted: currentIndex = indexOfValue(cfg_defaultIconName)
            onActivated: cfg_defaultIconName = currentValue //cbItems.get(currentIndex).value
        }
    }
}
