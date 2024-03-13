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

import QtQuick 6.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 6.0 as QtControls

import org.kde.plasma.core 2.0 as PlasmaCore
//import org.kde.plasma.components 5.62 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

// plasma pulseaudio plugin
import org.kde.plasma.private.volume 0.1

PlasmoidItem {
    id: main

    Layout.minimumWidth: gridLayout.implicitWidth
    Layout.minimumHeight: gridLayout.implicitHeight
    preferredRepresentation: fullRepresentation

    property int labeling: plasmoid.configuration.labeling
    property bool usePortDescription: plasmoid.configuration.usePortDescription

    property bool useVerticalLayout: plasmoid.configuration.useVerticalLayout

    property bool sourceInsteadofSink: plasmoid.configuration.sourceInsteadofSink

    readonly property var sinkModelFiltered: PulseObjectFilterModel {
        id: sinkModelFiltered
        filters: []
        filterOutInactiveDevices: true  // ← This avoids showing devices that can't be selected.
        filterVirtualDevices: false
        sourceModel: SinkModel {}
    }
    readonly property var sourceModelFiltered: PulseObjectFilterModel {
        id: sourceModelFiltered
        filters: []
        filterOutInactiveDevices: true  // ← This avoids showing devices that can't be selected.
        filterVirtualDevices: false
        sourceModel: SourceModel {}
    }
    property var filteredModel: sourceInsteadofSink ? sourceModelFiltered : sinkModelFiltered

    property string defaultIconName: plasmoid.configuration.defaultIconName

    // Inspired by:
    // https://github.com/KDE/plasma-pa/blob/master/applet/contents/code/icon.js
    // https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/blob/300db779224625144d6279d230c2daa857c967d8/src/modules/alsa/alsa-mixer.c#L2794
    // https://github.com/Apxdono/plasma-audio-device-switcher/commit/762ef92e5129c8b08bd94939bf2e88473217f84e
    function formFactorIcon(device, port, fallback) {
        // On my machine, device.formFactor returns nice values for sources,
        // but mostly useless values for sinks.
        //
        // This code here tries to be "smart" and look at multiple sources for
        // finding the best icon.

        // Some devices (e.g. the Null devices), don't have any ports.
        if (!port) {
            port = {}
        }

        const iconName          = device.iconName    || ""  // Usually empty, thus useless
        if (iconName) {
            return iconName;
        }

        const data = {
            formFactor:        device.formFactor  || "",  // e.g. "internal", "webcam", "microphone"
            deviceName:        device.name        || "",  // e.g. "alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1"
            portName:          port.name          || "",  // e.g. "hdmi-output-1"
            deviceDescription: device.description || "",  // e.g. "Built-in Audio Digital Stereo (HDMI 2)"
            portDescription:   port.description   || "",  // e.g. "HDMI / DisplayPort 2"
        }

        // Removing number suffixes:
        data.portName = data.portName.replace(/-[0-9]+$/, "")

        // console.log(JSON.stringify(data, null, 2));  // DEBUG

        const rules = [
            // Generic names and icons. Lowest score.
            {
                icon: "audio-card",
                score: 1,
                formFactor: /^internal$/i,
                portName: /^analog-input$|^analog-input-video|^analog-output(-mono)?$/i
            },
            {
                icon: "audio-card",
                score: 1,
                // LINE in/out don't have good icons.
                portName: /^analog-input-linein|^analog-output-lineout|^multichannel-input|^multichannel-output/i
            },
            {
                icon: "portable",
                score: 2,
                formFactor: /^portable$/i,
            },
            {
                icon: "computer",
                // icon: "computer-symbolic",
                score: 2,
                formFactor: /^computer$/i,
            },
            {
                icon: "preferences-system-bluetooth",
                // icon: "network-bluetooth",
                score: 2,
                deviceName: /^bluez/i,
            },
            {
                icon: "media-removable-symbolic",
                // icon: "drive-removable-media-usb",
                // icon: "drive-removable-media-usb-pendrive",
                score: 2,
                deviceName: /^alsa[^.]+\.usb/i,
            },
            {
                icon: "question",
                score: 1,
                // The Null output and Null input devices.
                deviceName: /^null-/i,
            },

            // Basic audio devices.
            {
                icon: "audio-speakers-symbolic",
                // icon: "speaker",
                score: 3,
                formFactor: /^speaker$/i,
                portName: /^analog-output-speaker/i,
            },
            {
                icon: "audio-input-microphone",
                // icon: "audio-input-microphone-symbolic",
                // icon: "microphone",
                score: 3,
                formFactor: /^microphone$/i,
                portName: /^analog-input-microphone(?!-headset)|analog-input-mic$/i,
            },
            {
                icon: "audio-headphones",
                // icon: "headphone",
                // icon: "headphones",
                score: 3,
                formFactor: /^headphone$/i,
                portName: /^analog-output-headphones?|^virtual-surround-7.1/i,
            },
            {
                icon: "audio-headset",
                // icon: "headset",
                score: 4,
                formFactor: /^headset$/i,
                portName: /^analog-input-microphone-headset|^analog-chat-(input|output)|^steelseries-arctis/i,
            },

            // Mobile phones. Quite unique names.
            {
                // icon: "phone",
                icon: "phone-symbolic",
                score: 3,
                formFactor: /^phone$/i,
            },
            {
                icon: "handset",  // Looks just like the "phone" icon.
                score: 3,
                formFactor: /^handset$/i,
            },
            {
                icon: "hands-free",
                score: 3,
                formFactor: /^hands-free$/i,
            },

            // A/V devices.
            {
                // icon: "video-television",
                icon: "tv",
                // icon: "tv-symbolic",
                score: 4,
                formFactor: /^tv$/i,
            },
            {
                icon: "video-display",
                score: 4,
                portName: /^hdmi-output/i,
            },
            {
                icon: "hifi",
                score: 4,
                formFactor: /^hifi$/i,
                // People using S/PDIF digital signaling are likely using Hi-Fi systems.
                portName: /^iec958-/i,
            },
            {
                icon: "audio-radio",
                // icon: "audio-radio-symbolic",
                // icon: "radio",
                score: 4,
                portName: /^analog-input-radio/,
            },
            {
                icon: "camera-web",
                // icon: "camera-web-symbolic",
                // icon: "webcam",
                score: 4,
                formFactor: /^webcam$/i,
            },

            // Other devices.
            {
                icon: "car",
                score: 4,
                formFactor: /^car$/i,
            },
        ]

        let icon = fallback || "audio-card"
        let score = 0

        // This function may be a bit slow if it is called too often.
        // TODO: Figure out how to cache this result.
        for (const rule of rules) {
            for (const attr of Object.keys(data)) {
                if (rule[attr]) {
                    // console.log("TESTING", attr, data[attr], rule[attr])  // DEBUG
                    if (rule[attr].test(data[attr])) {
                        // console.log("MATCH!", attr, "=", data[attr], "icon=", rule.icon, "score=", rule.score)  // DEBUG
                        if (rule.score >= score) {
                            icon = rule.icon
                            score = rule.score
                        }
                    }
                }
            }
        }

        return icon
    }

    GridLayout {
        id: gridLayout
        flow: useVerticalLayout? GridLayout.TopToBottom : GridLayout.LeftToRight
        anchors.fill: parent

        Repeater {
            model: filteredModel

            delegate: QtControls.ToolButton {
                id: tab
                enabled: currentPort !== null

                text: labeling != 2 ? currentDescription + (device.muted ? " (muted)" : "") : ""
                icon.name: labeling != 1 ? formFactorIcon(device, currentPort, defaultIconName) : ""

                checkable: true
                autoExclusive: true

                QtControls.ToolTip {
                    visible: hovered
                    text: currentDescription
                }

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: -1


                readonly property var device: model.PulseObject
                readonly property var currentPort: model.Ports[ActivePortIndex]
                readonly property string currentDescription: usePortDescription ? currentPort ? currentPort.description : model.Description : model.Description

                Binding {
                    target: tab
                    property: "checked"
                    value: device.default
                }

                onClicked: {
                    device.default = true
                }
            }
        }
    }
}
