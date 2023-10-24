// EasyLaunch
// Copyright (C) 2023 VGmove
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
	id: games
	anchors.fill: parent
	color: "transparent"

	property var currentCollection
	readonly property var currentGame: gameView.model.get(gameView.currentIndex)

	GridView {
		id: gameView
		delegate: itemDelegate
		model: currentCollection.games
		anchors.fill: parent
		interactive: true
		focus: true
		clip: true

		cellWidth: parent.width / 4
		cellHeight: cellWidth * 0.6
		keyNavigationWraps: false
		highlightMoveDuration: 100
		highlightFollowsCurrentItem: true

		onCurrentIndexChanged: { 
			select.play()
		}
	}

	Component {
		id: itemDelegate
		Item {
			width: gameView.cellWidth
			height: gameView.cellHeight

			Image {
				id: logo
				smooth: false
				asynchronous: true
				anchors.fill: parent
				anchors.margins: vpx(10)

				sourceSize.width: 320
				sourceSize.height: 240

				fillMode: Image.PreserveAspectCrop
				scale: parent.activeFocus ? 1.03 : 1
				Behavior on scale {NumberAnimation {duration: 100}}

				source: assets.logo
				onStatusChanged: {
					if (logo.status == Image.Error) { source = "../assets/img/none.jpg" }
					if (logo.status == Image.Ready) { fadeIn.start() }
				}
				
				Rectangle {
					id: border
					anchors.fill: parent
					anchors.margins: vpx(-3)
					color: "transparent"
					border.color: "white"
					radius: vpx(3)
					border.width: parent.parent.activeFocus ? vpx(4) : vpx(0)
				}
			}

			NumberAnimation on opacity {
				id: fadeIn
				from: 0
				to: 1
				duration: 1500
				easing.type: Easing.OutBack 
			}

			 Image {
				anchors.centerIn: parent
				visible: logo.status === Image.Loading
				source: "../assets/img/loading.png"

				NumberAnimation on rotation {
					from: 0
					to: 360
					duration: 1000
					loops: Animation.Infinite
				}
			}
			
			Keys.onPressed: {
				if (api.keys.isAccept(event) && !event.isAutoRepeat) {
					event.accepted = true;
					currentGame.launch()
				}
			}
			
			MouseArea {
				anchors.fill: parent
				onClicked: {
					gameView.forceActiveFocus()
					gameView.currentIndex = index
				}

				onDoubleClicked: {
					currentGame.launch()
				}
			}
		}
	}
}