import QtQuick 2.2
import QtQuick.Controls 1.1

ApplicationWindow {
    id: root
    visible: true
    width: 450
    height: 130
    title: qsTr("File downloader")

    function downloadProgress(downloaded_size, max_size){
        progress_bar_download.max_value = max_size;
        progress_bar_download.setValue(downloaded_size);
    }

    function downloadFinished(){
        startDownloading(false);
    }

    function downloadSpeed(kb_s){
        progress_bar_download.speed = kb_s;
    }

    function downloadError(err){
        startDownloading(false);
    }

    function startDownloading(status){
        if(status){
            btn_download.activated = false;
            btn_download.text = "Downloading ...";
            downloader.downloadUrl(download_url.displayText);
            download_url.enabled = false;
        }else{
            btn_download.activated = true;
            btn_download.text = "Download";
            download_url.enabled = true;
            download_url.displayText = "";
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    Rectangle {
        id: top_bar
        width: root.width
        height: root.height

        Image {
            anchors.fill: top_bar
            fillMode: Image.PreserveAspectCrop
            source: "img/bg.jpg"
            clip: true
        }

        FocusScope {
            anchors.fill: top_bar
            focus: true

            Rectangle {
                width: parent.width
                height: 30
                radius: 10
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: 10
                }
                color: "white"
                opacity: 0.5
                TextInput {
                    id: download_url
                    anchors {
                        fill: parent
                        centerIn: parent
                        margins: 5
                    }
                    focus: true
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                }
            }
        }
        Rectangle {
            id: btn_download
            height: 35
            width: 130
            radius: 10
            property alias text: btn_download_txt.text
            property bool activated: false
            anchors {
                right: top_bar.right
                bottom: top_bar.bottom
                margins: 10
            }
            color: "#214955"
            opacity: 0.8
            Text {
                id: btn_download_txt
                text: "Download"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    console.log(btn_download.activated);
                    if(!btn_download.activated){
                        startDownloading(true);
                    }
                }
            }
        }
        CustomProgressBar {
            id: progress_bar_download
            height: 35
            radius: 10
            opacity: 0.5
            anchors {
                bottom: top_bar.bottom
                left: top_bar.left
                right: btn_download.left
                margins: 10
            }
        }
    }

    Component.onCompleted: {
        downloader.progress.connect(downloadProgress);
        downloader.finished.connect(downloadFinished);
        downloader.speed.connect(downloadSpeed);
        downloader.downloadError.connect(downloadError);
    }
}
