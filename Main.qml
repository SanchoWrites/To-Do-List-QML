import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Controls
import QT_to_do_list 1.0

Window {
    width: 480; height: 640
    minimumWidth: 480
    minimumHeight: 640
    visible: true
    title: qsTr("To do list")
    TaskModel {
        id: cppModel
    }
    Rectangle {
        id: header
        width: parent.width; height: 150
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: "tomato"
        radius: 40
        anchors.topMargin: -50
        Text {
            id: allTasksText
            text: "ALL TASKS"
            color: "white"
            font.pixelSize: 50
            font.bold: true
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
        }
        Image{
            source: "images/notepad.png"
            width: 40
            height: 40
            fillMode: Image.PreserveAspectFit
            anchors.left: allTasksText.right
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: allTasksText.verticalCenter
            mipmap: true
        }
        Image{
            source: "images/nine_dots.png"
            width: 40
            height: 40
            fillMode: Image.PreserveAspectFit
            anchors.right: allTasksText.left
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: allTasksText.verticalCenter
            mipmap: true
        }
    }


    RowLayout {
        id: row
        anchors.top: header.bottom
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 10
        Rectangle {
            Layout.fillWidth: true; Layout.fillHeight: true
            color: "#E3E3E3"
            radius: 5
            MouseArea {
                id: taskInputMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.IBeamCursor
            }
            TextInput {
                id: taskInput
                anchors.fill: parent
                anchors.margins: 10
                verticalAlignment: Text.AlignVCenter
                clip: true
                color: "black"

                Text {
                    text: "Enter a new task..."
                    color: "#aaa"
                    visible: !taskInput.text && !taskInput.activeFocus
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 80; Layout.fillHeight: true
            radius: 5
            color: addMouseArea.containsMouse ? "#DB523D" : "#FF6347"
            Text {
                text: "Add"
                color: "white"
                anchors.centerIn: parent
                font.bold: true
            }
            MouseArea {
                id: addMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (taskInput.text !== "") {
                        cppModel.addTask(taskInput.text)
                        taskInput.text = ""

                        listView.forceActiveFocus()
                        listView.currentIndex = listView.count - 1
                    }
                }
            }
        }
    }

    Rectangle {
        height: 200
        radius: 5
        anchors.top: row.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        color: "#E3E3E3"
        Component {
            id: taskDelegate
            Rectangle {
                id: taskItem
                radius: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 60
                anchors.rightMargin: 30
                height: Math.max(40, taskText.height + 20)
                MouseArea {
                    id: taskMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
                Rectangle {
                    id: completeButton
                    anchors.right: parent.left
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 40
                    radius: 10
                    color: model.completed ? "#D3F8D3" : (completeMouseArea.containsMouse ? "#CCCCCC" : "white")
                    Image {
                        source: "images/checkmark.svg"
                        anchors.centerIn: parent
                        width: 24; height: 24
                        mipmap: true
                        visible: model.completed
                    }
                    MouseArea {
                        id: completeMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: cppModel.toggleTask(index)
                    }
                }
                Rectangle {
                    id: deleteButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    width: 30
                    height: 30
                    color: "transparent"
                    Image {
                        source: "images/cross.svg"
                        anchors.centerIn: parent
                        width: 24
                        height: 24
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                    }
                    MouseArea {
                        id: trashMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            cppModel.removeTask(index)
                        }
                    }
                }
                Text {
                    id: taskText
                    text: model.task
                    color: model.completed ? "#aaa" : "black"
                    font.strikeout: model.completed
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: deleteButton.left
                    anchors.rightMargin: 10
                    wrapMode: Text.Wrap
                }
            }
        }

        ListView {
            id: listView
            anchors.fill: parent
            model: cppModel
            delegate: taskDelegate
            spacing: 10
            clip: true
            focus: true
            header: Item {
                    height: 10
                    width: parent.width
            }

            footer: Item {
                    height: 10
                    width: parent.width
            }
            ScrollBar.vertical: ScrollBar {
                active: true
                policy: ScrollBar.AlwaysOn
            }
        }
    }
}
