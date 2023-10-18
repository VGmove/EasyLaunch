// EasyLaunch Theme
// Copyright (C) 2023 ViktorGr
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
	id: background
	anchors.fill: parent
	
	Image {
		id: backgroundView
		smooth: true
		antialiasing: true
		anchors.fill: parent
		
		source: "../assets/img/background.jpg"
		fillMode: Image.PreserveAspectCrop
	}
}