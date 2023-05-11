/* Webcamoid, webcam capture application.
 * Copyright (C) 2019  Gonzalo Exequiel Pedone
 *
 * Webcamoid is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Webcamoid is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Webcamoid. If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: http://webcamoid.github.io/
 */

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Templates 2.15 as T
import Ak 1.0
import "Private"

T.SwitchDelegate {
    id: control
    icon.width: AkUnit.create(18 * AkTheme.controlScale, "dp").pixels
    icon.height: AkUnit.create(18 * AkTheme.controlScale, "dp").pixels
    icon.color: activeWindowText
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + implicitIndicatorWidth
                            + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    padding: AkUnit.create(4 * AkTheme.controlScale, "dp").pixels
    leftPadding: AkUnit.create(16 * AkTheme.controlScale, "dp").pixels
    rightPadding: AkUnit.create(16 * AkTheme.controlScale, "dp").pixels
    spacing: AkUnit.create(20 * AkTheme.controlScale, "dp").pixels
    hoverEnabled: true
    clip: true

    readonly property int animationTime: 200
    readonly property color activeHighlight: AkTheme.palette.active.highlight
    readonly property color activeHighlightedText: AkTheme.palette.active.highlightedText
    readonly property color activeWindow: AkTheme.palette.active.window
    readonly property color activeWindowText: AkTheme.palette.active.windowText
    readonly property color disabledHighlight: AkTheme.palette.disabled.highlight
    readonly property color disabledHighlightedText: AkTheme.palette.disabled.highlightedText
    readonly property color disabledWindow: AkTheme.palette.disabled.window
    readonly property color disabledWindowText: AkTheme.palette.disabled.windowText

    indicator: Item {
        id: sliderIndicator
        anchors.right: control.right
        anchors.rightMargin: control.rightPadding
        anchors.verticalCenter: control.verticalCenter
        implicitWidth:
            AkUnit.create(36 * AkTheme.controlScale, "dp").pixels
        implicitHeight:
            AkUnit.create(20 * AkTheme.controlScale, "dp").pixels

        Rectangle {
            id: switchTrack
            height: parent.height / 2
            color: control.highlighted?
                      control.activeHighlightedText:
                      control. activeWindowText
            radius: height / 2
            anchors.verticalCenter: sliderIndicator.verticalCenter
            anchors.right: sliderIndicator.right
            anchors.left: sliderIndicator.left
        }
        Item {
            id: switchThumb
            width: height
            anchors.bottom: sliderIndicator.bottom
            anchors.top: sliderIndicator.top

            Rectangle {
                id: switchThumbRect
                color: control.highlighted?
                           control.activeHighlightedText:
                           control.activeWindowText
                radius: height / 2
                anchors.fill: parent
            }
        }
    }

    contentItem: IconLabel {
        id: iconLabel
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        iconName: control.icon.name
        iconSource: control.icon.source
        iconWidth: control.icon.width
        iconHeight: control.icon.height
        iconColor: control.highlighted?
                       control.activeHighlightedText:
                       control.icon.color
        text: control.text
        font: control.font
        color: control.highlighted?
                   control.activeHighlightedText:
                   control.activeWindowText
        alignment: Qt.AlignLeft | Qt.AlignVCenter
        anchors.left: control.left
        anchors.leftMargin: control.leftPadding
        anchors.right: sliderIndicator.left
        enabled: control.enabled
    }

    background: Rectangle {
        id: background
        implicitWidth:
            AkUnit.create(128 * AkTheme.controlScale, "dp").pixels
        implicitHeight:
            AkUnit.create(48 * AkTheme.controlScale, "dp").pixels
        color: control.highlighted?
                   control.activeHighlight:
                   AkTheme.shade(control.activeWindow, 0, 0)
    }

    states: [
        State {
            name: "Disabled"
            when: !control.enabled

            PropertyChanges {
                target: switchTrack
                color: control.highlighted?
                           control.disabledHighlightedText:
                           control.disabledWindowText
            }
            PropertyChanges {
                target: switchThumbRect
                color: control.highlighted?
                           control.disabledHighlightedText:
                           control.disabledWindowText
            }
            PropertyChanges {
                target: iconLabel
                color:
                    control.highlighted?
                        control.disabledHighlightedText:
                        control.disabledWindowText
            }
            PropertyChanges {
                target: background
                color: control.highlighted?
                           control.disabledHighlight:
                           AkTheme.shade(control.disabledWindow, 0, 0)
            }
        },
        State {
            name: "Checked"
            when: control.checked
                  && !(control.hovered
                       || control.visualFocus
                       || control.activeFocus)
                  && !control.pressed

            PropertyChanges {
                target: switchThumb
                x: sliderIndicator.width - switchThumb.width
            }
        },
        State {
            name: "Hovered"
            when: !control.checked
                  && (control.hovered
                      || control.visualFocus
                      || control.activeFocus)
                  && !control.pressed

            PropertyChanges {
                target: background
                color:
                    control.highlighted?
                        AkTheme.constShade(control.activeHighlight, 0.1):
                        AkTheme.shade(control.activeWindow, -0.1)
            }
        },
        State {
            name: "CheckedHovered"
            when: control.checked
                  && (control.hovered
                      || control.visualFocus
                      || control.activeFocus)
                  && !control.pressed

            PropertyChanges {
                target: switchThumb
                x: sliderIndicator.width - switchThumb.width
            }
            PropertyChanges {
                target: background
                color:
                    control.highlighted?
                        AkTheme.constShade(control.activeHighlight, 0.1):
                        AkTheme.shade(control.activeWindow, -0.1)
            }
        },
        State {
            name: "Pressed"
            when: !control.checked
                  && control.pressed

            PropertyChanges {
                target: background
                color:
                    control.highlighted?
                        AkTheme.constShade(control.activeHighlight, 0.2):
                        AkTheme.shade(control.activeWindow, -0.2)
            }
        },
        State {
            name: "CheckedPressed"
            when: control.checked
                  && control.pressed

            PropertyChanges {
                target: switchThumb
                x: sliderIndicator.width - switchThumb.width
            }
            PropertyChanges {
                target: background
                color:
                    control.highlighted?
                        AkTheme.constShade(control.activeHighlight, 0.2):
                        AkTheme.shade(control.activeWindow, -0.2)
            }
        }
    ]

    transitions: Transition {
        PropertyAnimation {
            target: switchTrack
            properties: "color"
            duration: control.animationTime
        }
        PropertyAnimation {
            target: switchThumb
            properties: "x"
            duration: control.animationTime
        }
        PropertyAnimation {
            target: switchThumbRect
            properties: "color"
            duration: control.animationTime
        }
        ColorAnimation {
            target: iconLabel
            duration: control.animationTime
        }
        ColorAnimation {
            target: background
            duration: control.animationTime
        }
    }
}
