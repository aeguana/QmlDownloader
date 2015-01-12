import QtQuick 2.0

Rectangle {
    id: body
    width: 100
    height: 62

    property int max_value: 100
    property int value: 0
    property alias speed: text_download_speed.text
    function setValue(val){
        var wid = (val / max_value) * body.width;
        progress.width = wid;
    }
    
    Rectangle {
        id: progress
        height: body.height
        width: (value / max_value) * body.width
        color: "#1c7766"
        radius: body.radius
    }

    Text {
        id: text_speed_label
        text: "Download speed:"
        anchors {
            left: progress.left
            verticalCenter: progress.verticalCenter
            margins: 10
        }
        color: "black"
    }
    Text {
        id: text_download_speed
        text: "0"
        anchors.bottomMargin: 10
        anchors {
            left: text_speed_label.right
            verticalCenter: progress.verticalCenter
            margins: 10
        }
        color: "black"
    }
    Text {
        text: "kB/s"
        anchors.bottomMargin: 10
        anchors {
            left: text_download_speed.right
            verticalCenter: progress.verticalCenter
            margins: 10
        }
        color: "black"
    }
}
