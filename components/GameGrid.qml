import QtQuick 2.0
import QtGraphicalEffects 1.0 

FocusScope {
	id: gameGrid
	width: Math.min(parent.width - 20, maxWidthLayout)
	height: parent.height
	anchors.horizontalCenter: parent.horizontalCenter

	property var currentCollection
	property alias currentIndex: gameGridView.currentIndex
	readonly property var currentGame: gameGridView.model.get(currentIndex)

	property int minCellWidth: maxWidthLayout / maxColumnGame
    property int columns: Math.max(1, Math.floor(gameGridView.width / minCellWidth))
	onWidthChanged: columns = Math.max(1, Math.floor(gameGridView.width / minCellWidth))

	KeyNavigation.up: headerContainer

	onCurrentIndexChanged: {
		if (activeFocus) {
			select.play();
		}
	}

	onActiveFocusChanged: {
		select.play()
	}

	GridView {
		id: gameGridView
		cellWidth: width / columns
		cellHeight: cellWidth * 0.6 // 10:6
		anchors.fill: parent
		topMargin: 8
		bottomMargin: 8
		model: currentCollection.games
		currentIndex: 0
		interactive: true
		clip: true
		focus: true
		keyNavigationWraps: false
		highlightMoveDuration: 100
		highlightFollowsCurrentItem: true

		delegate: Item {
			id: gameItem
			width: gameGridView.cellWidth
			height: gameGridView.cellHeight
			
			Item {
				anchors.fill: parent
				anchors.margins: itemMargin

				property real itemMargin: gameItem.activeFocus ? 0 : 4
				Behavior on itemMargin {
					NumberAnimation { 
						duration: 100; 
						easing.type: Easing.OutCubic 
					}
				}

				Rectangle {
					anchors.fill: parent
					color: theme.highlight
					opacity: gameItem.activeFocus ? 1.0 : 0.0
					radius: gridItemRadius + 2
				}
				
				Image {
					id: logo
					anchors.fill: parent
					anchors.margins: 4
					source: assets.logo
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectCrop

					layer.enabled: true
					layer.effect: OpacityMask {
						maskSource: Rectangle {
							width: logo.width
							height: logo.height
							radius: gridItemRadius
						}
					}

					Rectangle {
						anchors.fill: parent
						color: theme.panels
						radius: gridItemRadius
						visible: logo.status !== Image.Ready

						Image {
							width: 40
							height: 40
							anchors.centerIn: parent
							asynchronous: false
							smooth: true
							source: (logo.status === Image.Null || logo.status === Image.Error) 
								? "../assets/icons/not_found.svg" 
								: (logo.status === Image.Loading)
								? "../assets/icons/loading.svg" 
								: ""
							
							NumberAnimation on rotation {
								running: logo.status === Image.Loading
								from: 0; 
								to: 360; 
								duration: 1000; 
								loops: Animation.Infinite
							}
						}
					}
				}

				Text {
					width: parent.width - 20
					anchors.left: parent.left
					anchors.bottom: parent.bottom
					anchors.margins: 10
					text: modelData.title
					color: "white"
					font.pixelSize: 14
					font.family: regular.name
					wrapMode: Text.Wrap
					opacity: gameItem.activeFocus ? 1.0 : 0.0
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					gameGridView.forceActiveFocus();
					gameGridView.currentIndex = index;
				}

				onDoubleClicked: {
					currentGame.launch();
				}
			}

			Keys.onPressed: {
				if (api.keys.isAccept(event) && !event.isAutoRepeat) {
					event.accepted = true;
					currentGame.launch();
				}
			}
		}
	}
}
