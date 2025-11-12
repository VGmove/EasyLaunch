import QtQuick 2.0

Rectangle {
	id: batteryContainer
	width: 40
	height: 40
	color: "transparent"

	Image {
		width: parent.width - 10
		height: parent.height
		anchors.centerIn: parent
		asynchronous: false
		fillMode: Image.PreserveAspectFit
		source: {
			if (!isNaN(api.device.batteryPercent)) {
				var batteryPercent = Math.round(api.device.batteryPercent * 100)
				if (api.device.batteryCharging) {
					"../assets/icons/battery_on.svg";
				}
				else if (batteryPercent >= 75){
					"../assets/icons/battery_100.svg";
				}
				else if (batteryPercent >= 50){
					"../assets/icons/battery_75.svg";
				}
				else if (batteryPercent >= 25){
					"../assets/icons/battery_50.svg";
				}
				else if (batteryPercent >= 0){
					"../assets/icons/battery_25.svg";
				}
			}
		}
	}
}