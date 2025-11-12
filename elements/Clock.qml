import QtQuick 2.0

Rectangle {
	id: clockContainer
	width: 60
	height: 40
	color: "transparent"

	Text {
		anchors.centerIn: parent
		text: new Date().toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
		font.family: regular.name
		font.pixelSize: 20
		color: "white"
	}
}