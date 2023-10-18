// EasyLaunch Theme
// Copyright (C) 2023 ViktorGr
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
	id: helpers
	anchors.fill: parent
	color: "#282a30"

    Row {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: vpx(20)
		spacing: 20

		Repeater { 
			model: [
				{img : "../assets/controls/navigation.png", text : "Navigation"},
				{img : "../assets/controls/launch.png", text : "Launch"},
				{img : "../assets/controls/menu.png", text : "Menu"}
			]

			Rectangle { 
				width: childrenRect.width
				height: vpx(20)
				color: "transparent"
				
				Image {
					id: icon
					width: parent.height
					height: width
					source: modelData.img
					fillMode: Image.PreserveAspectFit
				}

				Text {
					color: "white"
					text: modelData.text
					anchors.left: icon.right
					anchors.verticalCenter: icon.verticalCenter 
					font.family: regular.name
					font.pixelSize: vpx(12)
				}
			}
        }
    }
}