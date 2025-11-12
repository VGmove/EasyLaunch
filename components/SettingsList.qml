import QtQuick 2.0
import "../elements" as Element

FocusScope {
	id: settingsList
	width: Math.min(parent.width - 20, maxWidthLayout)
	height: parent.height
	anchors.horizontalCenter: parent.horizontalCenter

	ListModel {
		id: settingsModel
	}

	Component.onCompleted: {
		settingsModel.clear()
		settingsModel.append({ 
			name: "Sounds",
			settingsName: "sounds",
			value: settings.sounds,
			type: "toggle"
		})
		settingsModel.append({ 
			name: "Clock",
			settingsName: "showClock",
			value: settings.showClock,
			type: "toggle"
		})
		settingsModel.append({ 
			name: "Battery *",
			settingsName: "showBattery",
			value: settings.showBattery,
			type: "toggle"
		})
		settingsModel.append({ 
			name: "StatusBar",
			settingsName: "showStatusBar",
			value: settings.showStatusBar,
			type: "toggle"
		})
		settingsModel.append({ 
			name: "Game Count",
			settingsName: "showGameCount",
			value: settings.showGameCount,
			type: "toggle"
		})
		settingsModel.append({ 
			name: "Background Image",
			settingsName: "backgroundImage",
			value: settings.backgroundImage,
			type: "toggle"
		})
		settingsModel.append({ 
			name: "Opaque Panel",
			settingsName: "opaquePanel",
			value: settings.opaquePanel,
			type: "toggle"
		})
		settingsModel.append({ 
			name: "Color Scheme",
			settingsName: "colorScheme",
			value: settings.colorScheme,
			type: "list"
		})
	}

	onActiveFocusChanged: {
		if (activeFocus) {
			settingsListView.forceActiveFocus();
		}
	}

	// Settings back button
	Element.Button {
		id: settingsBackButton
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: 20
		focus: true
		icon: "../assets/icons/back.svg"

		KeyNavigation.right: settingsListView

		onActiveFocusChanged: {
			if (parent.visible) {
				select.play();
			}
		}

		onClicked: {
			hideSettings();
		}

		onPressed: {
			hideSettings();
		}

		function hideSettings() {
			mainContainer.visible = true;
			settingsContainer.visible = false;
			headerContainer.forceActiveFocus();
		}
	}

	ListView {
		id: settingsListView
		width: parent.width - 200
		height: Math.min(contentHeight, parent.height)
		anchors.centerIn: parent
		model: settingsModel
		spacing: 20
		interactive: true
		clip: false
		focus: true

		KeyNavigation.left: settingsBackButton

		onCurrentIndexChanged: {
			if (parent.visible) {
				select.play();
			}
		}

		delegate: Rectangle {
			width: settingsListView.width
			height: 60
			color: settingsListView.activeFocus && settingsListView.currentIndex === index 
					? theme.highlight 
					: "transparent"
			radius: 10

			Text {
				anchors.left: parent.left
				anchors.verticalCenter: parent.verticalCenter
				anchors.leftMargin: 20
				text: model.name
				color: "white"
				font.family: regular.name
				font.pixelSize: 20
			}

			// Тoggle switch
			property int offset: 3
			Rectangle {
				width: 60 + offset * 2
				height: 30 + offset * 2
				radius: 15 + offset
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter
				anchors.rightMargin: 20
				color: theme.background
				visible: model.type === "toggle"
				z: Infinity

				Rectangle {
					width: 60
					height: 30
					radius: 15
					anchors.centerIn: parent
					color: model.value === "yes" ? theme.highlight : theme.panels
				}

				Rectangle {
					width: 30
					height: 30
					radius: 15
					color: "white"
					anchors.verticalCenter: parent.verticalCenter
					x: model.value === "yes" ? parent.width - width - offset : offset
					Behavior on x { NumberAnimation { duration: 80 } }
				}

				MouseArea {
					anchors.fill: parent
					onClicked: {
						var newValue = model.value === "yes" ? "no" : "yes"
						settingsModel.setProperty(index, "value", newValue)
						api.memory.set(model.settingsName, newValue)
						accept.play();
					}
				}
			}

			// List selector
			Rectangle {
				visible: model.type === "list"
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter
				anchors.rightMargin: 5
				width: 120
				height: 50
				radius: 10
				color: theme.panels
				z: Infinity

				Text {
					anchors.centerIn: parent
					text: model.value
					color: "white"
					font.pixelSize: 16
				}

				MouseArea {
					anchors.fill: parent
					onClicked: {
						var currentIndex = colorSchemes.indexOf(model.value);
						var nextIndex = (currentIndex + 1) % colorSchemes.length;
						var newValue = colorSchemes[nextIndex];
						
						settingsModel.setProperty(index, "value", newValue);
						api.memory.set(model.settingsName, newValue);
						accept.play();
					}
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: settingsListView.currentIndex = index
			}

			Keys.onPressed: {
				if (api.keys.isAccept(event) && !event.isAutoRepeat) {
					event.accepted = true;
					accept.play();

					if (model.type === "toggle") {
						var newValue = model.value === "yes" ? "no" : "yes";
						settingsModel.setProperty(index, "value", newValue);
						api.memory.set(model.settingsName, newValue);
					} 
					else if (model.type === "list") {
						var currentIndex = colorSchemes.indexOf(model.value);
						var nextIndex = (currentIndex + 1) % colorSchemes.length;
						var newValue = colorSchemes[nextIndex];

						settingsModel.setProperty(index, "value", newValue);
						api.memory.set(model.settingsName, newValue);
					}
				}
			}
		}
	}
}