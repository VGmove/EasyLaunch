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
import QtMultimedia 5.9
import "template"

FocusScope {
	id: root

	FontLoader { id: regular; source: "assets/fonts/NotoSans-Regular.ttf" }
    FontLoader { id: bold; source: "assets/fonts/NotoSans-Bold.ttf" }
	
	MediaPlayer {
		id: home
		source: "assets/sounds/home.wav"
		volume: 1
		loops : 1
	}
	
	MediaPlayer {
		id: toggle
		source: "assets/sounds/toggle.wav"
		volume: 1
		loops : 1
	}

	MediaPlayer {
		id: select
		source: "assets/sounds/select.wav"
		volume: 1
		loops : 1
	}
	
	Component.onCompleted: {
        home.play()
    }

	Keys.onPressed: {
		if (api.keys.isNextPage(event) || api.keys.isPrevPage(event)) {
			mainCollections.focus = true
		}
	}
	
	Item{
		id: mainBackground
		anchors.fill: parent
		
		Background {
			id: background
			color: "blue"
		}
	}

	FocusScope {
        id: mainCollections
		focus: false
		
		width: parent.width
		height: vpx(120)

		anchors.leftMargin: vpx(120)
		anchors.rightMargin: vpx(120)
		anchors.top: mainHeader.bottom
		anchors.right: parent.right
		anchors.left: parent.left

        Collections {
			id: collections
		}

		Header {
			id: header
			currentCollection: collections.currentCollection
		}

		states: [
			State { when: mainCollections.activeFocus
				PropertyChanges {
					target: collections
					parent.height: vpx(300)
					visible: true
					opacity: 1.0
				}
				PropertyChanges {
					target: header
					visible: false
					opacity: 0.0
				}
			},
			State { when: !mainCollections.activeFocus;
				PropertyChanges {
					target: collections
					visible: false
					opacity: 0.0
				}
				PropertyChanges {
					target: header
					visible: true
					opacity: 1.0
				}
			}
		]
		transitions: Transition {
			NumberAnimation { property: "parent.height"; duration: 100}
			NumberAnimation { property: "opacity"; duration: 100}
		}
    }

	Rectangle {
		id: separator

		width: parent.width
		height: vpx(1)
		z: 1

		anchors.leftMargin: vpx(60)
		anchors.rightMargin: vpx(60)
		anchors.top: mainCollections.bottom
		anchors.right: parent.right
		anchors.left: parent.left
		color: "#a7adba"
	}

    FocusScope {
        id: mainGameGrid
		focus: true
		
		anchors.leftMargin: vpx(120)
		anchors.rightMargin: vpx(120)
		anchors.top: separator.bottom
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		anchors.left: parent.left

        GameGrid {
			id: gamegrid
			currentCollection: collections.currentCollection
		}
    }
}