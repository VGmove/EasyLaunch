import QtQuick 2.0
import QtQuick.Window 2.0
import "../elements" as Element

FocusScope {
	id: header
	width: Math.min(parent.width - 20, maxWidthLayout)
	height: parent.height
	anchors.horizontalCenter: parent.horizontalCenter
	focus: true

	property var currentCollection
	property int buttonIndex: 0
	property int buttonCount: 4

	Keys.onLeftPressed: buttonIndex = (buttonIndex - 1 + buttonCount) % buttonCount
	Keys.onRightPressed: buttonIndex = (buttonIndex + 1) % buttonCount

	onButtonIndexChanged: {
		if (activeFocus) {
			select.play()
		}
	}

	// Collection button
	Row {
		id: leftContainer
		anchors.left: parent.left
		anchors.verticalCenter: parent.verticalCenter
		spacing: 10

		Element.Button {
			id: collectionButton
			focus: header.buttonIndex === 0
			icon: "../assets/icons/collections.svg"
			
			onClicked: {
				collectionList.forceActiveFocus();
			}

			onPressed: {
				collectionList.forceActiveFocus();
			}
		}

		// Collection logo
		Image {
			id: collectionLogo
			width: 150
			height: parent.height
			asynchronous: false
			smooth: true
			fillMode: Image.PreserveAspectFit		
			source: "../assets/logos/" + currentCollection.name + ".svg"

			Text {
				color: "white"
				anchors.centerIn: parent
				text: currentCollection.name
				font.family: regular.name
				font.pixelSize: 24
				font.capitalization: Font.AllUppercase
				visible: collectionLogo.status === Image.Error
			}
		}

		// Game count round
		Rectangle {
			width: 24
			height: width
			anchors.verticalCenter: parent.verticalCenter
			radius: 25
			color: "transparent"
			border.color : "white"
			border.width : 1
			visible: settings.showGameCount === "yes"

			Text {
				anchors.centerIn: parent
				color: "white"
				text: currentCollection.games.count
				font.family: regular.name
				font.pixelSize: 10
			}
		}
	}

	Row {
		id: rightContainer
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		spacing: 10

		// Home collection button
		Element.Button {
			id: homeCollectionButton
			focus: header.buttonIndex === 1
			icon: isCurrentHome ? "../assets/icons/home_on.svg" : "../assets/icons/home_off.svg"

			property bool isCurrentHome: settings.homeCollection === currentCollection.name
			
			onClicked: {
				setHomeCollection();
			}

			onPressed: {
				setHomeCollection();
			}

			function setHomeCollection() {
				if (isCurrentHome) {
					api.memory.set("homeCollection", "")
				} else {
					api.memory.set("homeCollection", currentCollection.name)
				}
				settings.homeCollection = currentCollection.name
			}
		}

		// Home fullScreen button
		Element.Button {
			id: fullScreenButton
			focus: header.buttonIndex === 2
			icon: "../assets/icons/fullscreen.svg"

			onClicked: {
				toggleFullScreen();
			}

			onPressed: {
				toggleFullScreen();
			}

			function toggleFullScreen() {
				if (visibility === Window.FullScreen) {
					api.memory.set("fullScreen", "no");
					showNormal();
				} else {
					api.memory.set("fullScreen", "yes");
					showFullScreen();
				}
			}
		}

		// Settings button
		Element.Button {
			id: settingsButton
			focus: header.buttonIndex === 3
			icon: "../assets/icons/settings.svg"

			onClicked: {
				showSettings();
			}

			onPressed: {
				showSettings();
			}

			function showSettings() {
				mainContainer.visible = false;
				settingsContainer.visible = true;
				settingsList.forceActiveFocus();
			}
		}

		// Indicator battery
		Element.Battery {
			id: battery
			visible: settings.showBattery === "yes" && !isNaN(api.device.batteryPercent)
		}

		// Indicator clock
		Element.Clock {
			id: clock
			visible: settings.showClock === "yes"
		}
	}
}