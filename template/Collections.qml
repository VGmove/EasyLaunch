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
	id: collections
	anchors.fill: parent
	color: "transparent"

	property alias currentIndex: collectionView.currentIndex
	readonly property var currentCollection: collectionView.model.get(currentIndex)

	function next() {
        collectionView.incrementCurrentIndex();
    }
    function prev() {
        collectionView.decrementCurrentIndex();
    }

	ListView {
        id: collectionView
		delegate: itemDelegate
		model: api.collections
		anchors.fill: parent
		interactive: true
		focus: true
		clip: false
		spacing: 40
		orientation: ListView.Horizontal
        snapMode: ListView.NoSnap
		keyNavigationWraps: false
		highlightMoveDuration: 150
		highlightFollowsCurrentItem: true

		preferredHighlightBegin: width /2 - currentItem.width /2
    	preferredHighlightEnd: width /2 + currentItem.width /2
		highlightRangeMode: ListView.StrictlyEnforceRange

		onActiveFocusChanged: {
			toggle.play()
		}
	}
	
	Component {
		id: itemDelegate
		Rectangle {
			id: item
			anchors.verticalCenter: parent.verticalCenter
			height: vpx(100)
			width: vpx(250)
			color: "transparent"

			Image {
				id: logo
				asynchronous: true
				anchors.fill: parent

				source: "../assets/logos/" + modelData.name + ".svg"
				onStatusChanged: {
					if (logo.status == Image.Error) label.opacity = 1
					else label.opacity = 0
				}
				fillMode: Image.PreserveAspectFit
				opacity: parent.ListView.isCurrentItem ? 1 : 0.2
				scale: parent.activeFocus ? 1 : 0.75
				Behavior on scale { NumberAnimation { duration: 100} }

				Text {
					id: label
					anchors.centerIn: parent
					color: "white"
					text: modelData.name
					font.pixelSize: vpx(24)
					font.family: regular.name
					font.capitalization: Font.AllUppercase
				}
			}
			
			Keys.onPressed: {
				if (api.keys.isNextPage(event)) {
					next();
				}
				if (api.keys.isPrevPage(event)) {
					prev();
				}
			}
			
			MouseArea {
				anchors.fill: parent
				onClicked: {
					collectionView.focus = true
					collectionView.currentIndex = index
				}
				onWheel: {
					wheel.accepted = true;
					if (wheel.angleDelta.x > 0 || wheel.angleDelta.y > 0)
						prev();
					else
						next();
				}
			}
		}
	}
}