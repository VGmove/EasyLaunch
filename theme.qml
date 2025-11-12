// EasyLaunch
// Copyright (C) 2025 VGmove
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
import "components"

FocusScope {
	id: root
	
	FontLoader { id: regular; source: "assets/fonts/NotoSans-Regular.ttf" }
	FontLoader { id: bold; source: "assets/fonts/NotoSans-Bold.ttf" }

	property int maxWidthLayout: 1200
	property int maxColumnGame: 4
	property int gridItemRadius: 6
	property int slideDownHeight: 200

	readonly property var settings: {
		return {
			fullScreen:			api.memory.has("fullScreen") ? api.memory.get("fullScreen") : "no",
			homeCollection:		api.memory.has("homeCollection") ? api.memory.get("homeCollection") : "",

			sounds:				api.memory.has("sounds") ? api.memory.get("sounds") : "yes",
			showClock:			api.memory.has("showClock") ? api.memory.get("showClock") : "yes",
			showBattery:		api.memory.has("showBattery") ? api.memory.get("showBattery") : "yes",
			showGameCount:		api.memory.has("showGameCount") ? api.memory.get("showGameCount") : "yes",
			showStatusBar:		api.memory.has("showStatusBar") ? api.memory.get("showStatusBar") : "yes",
			backgroundImage:	api.memory.has("backgroundImage") ? api.memory.get("backgroundImage") : "yes",
			opaquePanel:		api.memory.has("opaquePanel") ? api.memory.get("opaquePanel") : "yes",
			colorScheme:		api.memory.has("colorScheme") ? api.memory.get("colorScheme") : "Gray"
		}
	}

	readonly property var colorSchemes: ["Gray", "Steel", "Graphite", "Fly", "Oliva", "Violet"]
	readonly property var theme: {
		var panels = "";
		var highlight = "";
		var background = "";

		if (settings.colorScheme === "Gray") {
			panels = "#4a4a4a";
			highlight = "#437fc4";
			background = "#363636";
		}
		else if (settings.colorScheme === "Steel") {
			panels = "#5c6c7f";
			highlight = "#b5a27d";
			background = "#444f5c";
		}
		else if (settings.colorScheme === "Graphite") {
			panels = "#363d4b";
			highlight = "#7da3ca";
			background = "#20262d";
		}

		else if (settings.colorScheme === "Fly") {
			panels = "#466870";
			highlight = "#d35b5b";
			background = "#244454";
		}

		else if (settings.colorScheme === "Oliva") {
			panels = "#414f56";
			highlight = "#a0b684";
			background = "#20292a";
		}

		else if (settings.colorScheme === "Violet") {
			panels = "#222738";
			highlight = "#9072ed";
			background = "#151823";
		}

		return {
			panels: panels,
			highlight: highlight,
			background: background
		}
	}
	
	MediaPlayer {
		id: home
		source: "assets/sounds/home.wav"
		volume: settings.sounds === "yes" ? 1 : 0
		loops : 1
	}

	MediaPlayer {
		id: accept
		source: "assets/sounds/accept.wav"
		volume: settings.sounds === "yes" ? 1 : 0
		loops : 1
	}

	MediaPlayer {
		id: toggle
		source: "assets/sounds/toggle.wav"
		volume: settings.sounds === "yes" ? 1 : 0
		loops : 1
	}

	MediaPlayer {
		id: select
		source: "assets/sounds/select.wav"
		volume: settings.sounds === "yes" ? 1 : 0
		loops : 1
	}

	Component.onCompleted: {
		home.play();

		// Set fullscreen
		switch(settings.fullScreen) {
			case "yes":
				showFullScreen();
				break;
			default:
				showNormal();
		}

		// Set home collection
		var homeCollectionName = api.memory.get("homeCollection")
		if (homeCollectionName) {
			for (var i = 0; i < api.collections.count; i++) {
				if (api.collections.get(i).name === homeCollectionName) {
					collectionList.currentIndex = i;
					break;
				}
			}
		}
	}

	// Background
	Item{
		id: mainBackground
		anchors.fill: parent

		Rectangle {
			id: background
			anchors.fill: parent
			color: theme.background
		}
		
		Image {
			id: backgroundOverlay
			smooth: true
			antialiasing: true
			anchors.fill: parent
			source: "assets/img/background.jpg"
			fillMode: Image.PreserveAspectCrop
			visible: settings.backgroundImage === "yes"
		}
	}

	FocusScope {
		id: mainContainer
		anchors.fill: parent
		focus: true

		// Collection Container
		FocusScope {
			id: collectionContainer
			width: parent.width
			anchors.top: headerContainer.top
			visible: opacity > 0
			z: Infinity

			Behavior on height { NumberAnimation { duration: 100 }}
			Behavior on opacity { NumberAnimation { duration: 100 }}

			Rectangle {
				id: collectionBackground
				anchors.fill: parent
				visible: settings.opaquePanel === "yes"
				color: theme.panels
			}

			CollectionList {
				id: collectionList
			}
		}

		// Header Container
		FocusScope {
			id: headerContainer
			width: parent.width
			height: 60
			focus: true
			clip: true

			Behavior on opacity { NumberAnimation { duration: 100 }}

			Rectangle {
				id: headerSeparator
				width: headerContainer.width
				height: 1
				anchors.bottom: headerContainer.bottom
				visible: headerBackground.visible ? false : true
				color: "#777"
			}

			Rectangle {
				id: headerBackground
				anchors.fill: parent
				visible: settings.opaquePanel === "yes"
				color: theme.panels
			}

			Header {
				id: header
				currentCollection: collectionList.currentCollection
			}
		}

		// Game Container
		FocusScope {
			id: gameGridContainer
			width: parent.width
			anchors.top: headerContainer.bottom
			anchors.bottom: statusBarContainer.top

			Behavior on anchors.topMargin { NumberAnimation { duration: 100 }}

			GameGrid {
				id: gameGrid
				currentCollection: collectionList.currentCollection
			}
		}

		// StatusBar Container
		FocusScope {
			id: statusBarContainer
			width: parent.width
			height: visible ? 40 : 0
			anchors.bottom: parent.bottom
			visible: settings.showStatusBar === "yes"

			Rectangle {
				id: statusBarSeparator
				width: statusBarContainer.width
				height: 1
				anchors.top: statusBarContainer.top
				visible: statusBarBackground.visible ? false : true
				color: "#777"
			}

			Rectangle {
				id: statusBarBackground
				anchors.fill: parent
				visible: settings.opaquePanel === "yes"
				color: theme.panels
			}

			StatusBar {
				id: statusBar
				currentCollection: collectionList.currentCollection
				currentGame: gameGrid.currentGame
			}
		}		
	}

	// Settings screen
	FocusScope {
		id: settingsContainer
		anchors.fill: parent
		visible: false

		Rectangle {
			id: settingsBackground
			anchors.fill: parent
			color: theme.background
		}

		SettingsList {
			id: settingsList
		}
	}
}