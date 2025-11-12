import QtQuick 2.0

FocusScope {
	id: button
	width: 40
	height: 40
	focus: true

	property string icon: ""
	signal clicked()
	signal pressed()

	Rectangle {
		anchors.fill: parent
		color: button.activeFocus || buttonMouseArea.containsMouse 
				? theme.highlight 
				: "transparent"
		radius: 25
		
		Image {
			width: parent.width - 18
			height: parent.height - 18
			anchors.centerIn: parent
			asynchronous: false
			smooth: true
			source: button.icon
			fillMode: Image.PreserveAspectFit
		}
	}
	
	MouseArea {
		id: buttonMouseArea
		anchors.fill: parent
		hoverEnabled: true
		onClicked: {
			button.clicked();
			accept.play();
		}
	}
	
	Keys.onPressed: {
		if (api.keys.isAccept(event) && !event.isAutoRepeat) {
			event.accepted = true;
			button.pressed();
			accept.play();
		}
	}
}