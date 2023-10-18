// EasyLaunch Theme
// Copyright (C) 2023 Viktor Gr
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.0

Rectangle {
	id: header
	anchors.fill: parent
	color: "transparent"

	property var currentCollection

	Rectangle {
		id: nameCollection
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: vpx(20)
		width: childrenRect.width
		height: vpx(50)
		color: "transparent"

		Image {
			id: collectionLogo
			width: vpx(150)
			asynchronous: true
			fillMode: Image.PreserveAspectFit
			anchors.verticalCenter: parent.verticalCenter			
			source: "../assets/logos/" + currentCollection.name + ".svg"
			onStatusChanged: {
				if (collectionLogo.status == Image.Error) label.opacity = 1
				else label.opacity = 0
			}
			
			Text {
				id: label
				anchors.centerIn: parent
				color: "white"
				text: currentCollection.name
				font.pixelSize: vpx(24)
				font.capitalization: Font.AllUppercase
			}

			Rectangle {
				id: gameCountRound
				anchors.left: parent.right
				anchors.bottom: parent.top
				height: vpx(20)
				width: vpx(20)
				radius: 25
				color: "white"

				Text {
					id: gameCount
					anchors.verticalCenter: parent.verticalCenter
					anchors.horizontalCenter: parent.horizontalCenter
					color: "black"
					text: currentCollection.games.count
					font.family: regular.name
					font.pixelSize: vpx(12)
				}
			}
		}
		MouseArea {
			anchors.fill: parent
			onClicked: {
				mainCollections.forceActiveFocus()
			}
		}
	}

	Row {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: vpx(20)
		spacing: 40

		Rectangle {
			id: battary
			anchors.verticalCenter: parent.verticalCenter
			width: childrenRect.width
			height: vpx(50)
			color: "transparent"

			Image {
				id: battaryIcon
				width: vpx(30)
				asynchronous: true
				anchors.verticalCenter: parent.verticalCenter
				fillMode: Image.PreserveAspectFit
				source: {
					if (!isNaN(api.device.batteryPercent)) {
						var batteryPercent = Math.round(api.device.batteryPercent * 100)
						if (api.device.batteryCharging) {
							"../assets/img/battery_on.svg"
						}
						else if (batteryPercent >= 75){
							"../assets/img/battery_100.svg"
						}
						else if (batteryPercent >= 50){
							"../assets/img/battery_75.svg"
						}
						else if (batteryPercent >= 25){
							"../assets/img/battery_50.svg"
						}
						else if (batteryPercent >= 0){
							"../assets/img/battery_25.svg"
						}
					}
				}
			}
		}

        Rectangle {
			id: clock
			anchors.verticalCenter: parent.verticalCenter
			width: childrenRect.width
			height: vpx(50)
			color: "transparent"
			
            Text {
				anchors.verticalCenter: parent.verticalCenter
				text: new Date().toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
				font.family: regular.name
				font.pixelSize: vpx(20)
				color: "white"
			} 
		}
	}
}