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
import QtGraphicalEffects 1.12

Rectangle {
	id: games
	anchors.fill: parent
	color: "transparent"

	property var currentCollection
	
	function up() {
		gameView.moveCurrentIndexUp()
	}
	
	function down() {
		gameView.moveCurrentIndexDown()
	}
	
	function run() {
		currentCollection.games.get(gameView.currentIndex).launch()
	}

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

		KeyNavigation.up: mainCollections
		
		onCurrentIndexChanged: { 
			select.play()
		}
	}

	Component {
		id: itemDelegate
		Rectangle {
			id: item
			width: gameView.cellWidth
			height: gameView.cellHeight
			color: "transparent"

			Image {
				id: logo
				smooth: false
				asynchronous: true
				anchors.fill: parent
				anchors.margins: vpx(10)

				source: assets.logo
				onStatusChanged: {
					if (logo.status == Image.Error) { source = "../assets/img/none.jpg" }
					if (logo.status == Image.Ready) { fadeIn.start() }
				}
				fillMode: Image.PreserveAspectCrop
				scale: parent.activeFocus ? 1.03 : 1
				Behavior on scale {NumberAnimation {duration: 50}}

				NumberAnimation on opacity {
					id: fadeIn
					from: 0
               		to: 1
					duration: 200
				}
				
				Rectangle {
					id: border
					anchors.fill: parent
					
					color: "transparent"
					border.color: "white"
					radius: 10
					border.width: parent.parent.activeFocus ? vpx(3) : vpx(0)
				}

				layer.enabled: true
				layer.effect: OpacityMask {
					maskSource: Rectangle {
						width: logo.width
						height: logo.height
						radius: 10
					}
				}
			}
			
			Keys.onPressed: {
				if (api.keys.isAccept(event)) {
					run() 
				}
			}
			
			MouseArea {
				anchors.fill: parent
				onClicked: {
					gameView.forceActiveFocus()
					gameView.currentIndex = index
				}

				onDoubleClicked: {
					run() 
				}
			}
		}
	}
}