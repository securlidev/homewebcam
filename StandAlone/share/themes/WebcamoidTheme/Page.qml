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

T.Page {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            implicitHeaderWidth,
                            implicitFooterWidth)
    implicitHeight:
        Math.max(implicitBackgroundHeight + topInset + bottomInset,
                 contentHeight + topPadding + bottomPadding
                 + (implicitHeaderHeight > 0? implicitHeaderHeight + spacing: 0)
                 + (implicitFooterHeight > 0? implicitFooterHeight + spacing: 0))

    readonly property color activeWindow: AkTheme.palette.active.window
    readonly property color disabledWindow: AkTheme.palette.disabled.window

    background: Rectangle {
        color: enabled?
                   control.activeWindow:
                   control.disabledWindow
    }
}
