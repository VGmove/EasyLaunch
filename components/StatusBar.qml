import QtQuick 2.0

Rectangle {
	id: statusBar
	width: Math.min(parent.width - 20, maxWidthLayout)
	height: parent.height
	anchors.horizontalCenter: parent.horizontalCenter
	color: "transparent"

	property var currentGame
	property var currentCollection
	property string collectionInfo:
	`${currentCollection.name}   •   ${currentCollection.games.count} games   •   ${currentGame.title}`

	Text {
		anchors.left: parent.left
		anchors.verticalCenter: parent.verticalCenter
		color: "white"
		text: collectionInfo
		font.pixelSize: 12
		font.family: regular.name
		font.capitalization: Font.AllUppercase
	}
}