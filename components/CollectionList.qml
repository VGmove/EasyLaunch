import QtQuick 2.0

FocusScope {
	id: collectionList
	width: Math.min(parent.width - 20, maxWidthLayout)
	height: parent.height
	anchors.horizontalCenter: parent.horizontalCenter
	
	property alias currentIndex: collectionListView.currentIndex
	readonly property var currentCollection: collectionListView.model.get(currentIndex)

	KeyNavigation.down: headerContainer

	onCurrentIndexChanged: {
		if (parent.visible) {
			toggle.play();
		}
	}

	onActiveFocusChanged: {
		accept.play();
	}

	states: [
		State { when: collectionList.activeFocus
			PropertyChanges {
				target: collectionContainer
				height: slideDownHeight
				opacity: 1.0
			}
			PropertyChanges {
				target: headerContainer
				opacity: 0.0
			}
			PropertyChanges {
				target: gameGridContainer
				anchors.topMargin: slideDownHeight - headerContainer.height
			}
		},
		State { when: !collectionList.activeFocus;
			PropertyChanges {
				target: collectionContainer
				height: 0
				opacity: 0.0
			}
			PropertyChanges {
				target: headerContainer
				opacity: 1.0
			}
			PropertyChanges {
				target: gameGridContainer
				anchors.topMargin: 0
			}
		}
	]

	ListView {
		id: collectionListView
		delegate: collectionListItem
		model: api.collections
		anchors.fill: parent
		interactive: true
		clip: !activeFocus
		focus: true
		spacing: 40
		orientation: ListView.Horizontal
		snapMode: ListView.NoSnap
		keyNavigationWraps: false
		highlightMoveDuration: 150
		highlightFollowsCurrentItem: true

		preferredHighlightBegin: width /2 - currentItem.width /2
		preferredHighlightEnd: width /2 + currentItem.width /2
		highlightRangeMode: ListView.StrictlyEnforceRange
	}

	Component {
		id: collectionListItem
		Rectangle {
			id: item
			height: 100
			width: 250
			anchors.verticalCenter: parent.verticalCenter
			color: "transparent"

			Image {
				id: collectionListLogo
				asynchronous: false
				anchors.fill: parent

				source: "../assets/logos/" + modelData.name + ".svg"
				onStatusChanged: {
					if (collectionListLogo.status == Image.Error) collectionListLabel.opacity = 1
					else collectionListLabel.opacity = 0
				}
				fillMode: Image.PreserveAspectFit
				opacity: parent.ListView.isCurrentItem ? 1 : 0.2
				scale: parent.activeFocus ? 1 : 0.75
				Behavior on scale { NumberAnimation { duration: 100} }

				Text {
					id: collectionListLabel
					anchors.centerIn: parent
					color: "white"
					text: modelData.name
					font.pixelSize: 24
					font.family: regular.name
					font.capitalization: Font.AllUppercase
				}
			}
			
			Keys.onPressed: {
				if (api.keys.isNextPage(event)) {
					collectionListView.incrementCurrentIndex();
				}
				if (api.keys.isPrevPage(event)) {
					collectionListView.decrementCurrentIndex();
				}
				if (api.keys.isAccept(event)) {
					event.accepted = true;
					headerContainer.forceActiveFocus();
				}
			}
			
			MouseArea {
				anchors.fill: parent
				onClicked: {
					if (collectionListView.currentIndex === index) {
						headerContainer.forceActiveFocus();
					}
					collectionListView.currentIndex = index;
				}
				
				onWheel: {
					wheel.accepted = true;
					if (wheel.angleDelta.x > 0 || wheel.angleDelta.y > 0)
						collectionListView.decrementCurrentIndex();
					else
						collectionListView.incrementCurrentIndex();
				}
			}
		}
	}
}