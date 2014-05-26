import QtQuick 1.1

ListView {
    id: cpuListView
    property int direction: Qt.LeftToRight
    property bool multipleColor: false
    property color progressColor: "#993de515"
    property color progressColorCritical: "red"
    property color progressColorHigh: "#ffac2a"
    property color progressColorNormal: "#85a9ff"
    property int highValue: 87
    property int criticalVaue : 105
    property string labelData: "CPU"
    model: cpuModel
    FontLoader {
        id: doppioOneRegular
        source: "../fonts/Doppio_One/DoppioOne-Regular.ttf"
    }
    HighlightCpu {
        id: highlightCpu
        width: cpuListView.width
        height: if (cpuListView.currentItem) cpuListView.currentItem.height; else 0
        y: if (cpuListView.currentItem) cpuListView.currentItem.y; else 0
    }

    boundsBehavior: Flickable.StopAtBounds
    highlight: highlightCpu
    highlightFollowsCurrentItem: false
    delegate: Item {
        id: itemElement
        width: parent.width
        height: cpuListItem.height+1
        Column {
            id: cpuListItem
            width: parent.width
            Row {
                Text {
                    id: cpuLabel
                    text: labelData+' '+model.index+':'
                    font.bold: true
                    font { family: doppioOneRegular.name; pointSize: 10 }
                    color: "#ffdd55"
                }
                Text {
                    text: Math.floor(val)+'%'
                    font.bold: true
                    font.pointSize: 10
                    color: "white"
                }
                Component.onCompleted: {
                    if (direction === Qt.RightToLeft)
                        anchors.right = parent.right
                }
            }
            Rectangle {
                id: progressBar
                height: 8
                color: "transparent"
                //clip: true
                width: parent.width
                Rectangle {
                    // clear background
                    width: parent.width
                    height: parent.height
                    y:0
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 2
                    gradient: Gradient {
                        GradientStop {
                            position: 0.00;
                            color: "#99000000";
                        }
                        GradientStop {
                            position: 0.25;
                            color: "#55555555";
                        }
                        GradientStop {
                            position: 1.00;
                            color: "transparent";
                        }
                    }
                    border.color: "#33ffffff"
                }

                Rectangle {
                    id: rectValue
                    // rectangle with value changed and crop
                    height: parent.height
                    color: "transparent"
                    clip: true
                    border.color: "#33ffffff"
                    width: Math.floor(val/100*(parent.width-5))
                    Rectangle {
                        id: bgGradient
                        // rectangle of color, in background for less cpu load
                        height: progressBar.width
                        width: progressBar.height
                        gradient: Gradient {
                            GradientStop {
                                position: 1.00;
                                color: "#4dffffff";
                            }
                            GradientStop {
                                position: 0.00;
                                color: if (multipleColor == false) progressColor
                                       else { if (val>=criticalVaue) progressColorCritical
                                           else if (val>=highValue) progressColorHigh
                                           else progressColorNormal
                                       }
                            }
                        }
                        transform: [
                            Rotation { id: colorRotation; origin.x:0; origin.y:0; angle:0 },
                            Translate { id: colorTraslation; x: 0; y:0 } ]
                        Component.onCompleted: {
                            if (direction === Qt.RightToLeft) {
                                colorRotation.angle = 270
                                colorTraslation.y = width
                                anchors.left = parent.left
                            }
                            else {
                                colorRotation.angle = 90
                                colorTraslation.x = height
                            }
                        }

                    }
                    Rectangle {
                        // rectangle of shadow, in background for less cpu load
                        height: progressBar.height
                        width: progressBar.width
                        gradient: Gradient {
                            GradientStop {
                                position: 0.00;
                                color: "#99000000";
                            }
                            GradientStop {
                                position: 0.25;
                                color: "#55555555";
                            }
                            GradientStop {
                                position: 0.88;
                                color: "transparent";
                            }
                            GradientStop {
                                position: 1.00;
                                color: "#eeffffff";
                            }
                        }
                    }
                    Component.onCompleted: {
                        if (direction === Qt.RightToLeft)
                            anchors.right = progressBar.right
                        else
                            anchors.left= parent.left
                    }
                }
                Rectangle {
                    height: progressBar.height+4
                    width: 5
                    radius: 2
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#88ffffff"
                    Component.onCompleted: {
                        if (direction === Qt.RightToLeft)
                            anchors.right = rectValue.left
                        else
                            anchors.left = rectValue.right
                    }
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                cpuListView.currentIndex = index
                highlightCpu.visible = true
            }
            onExited: {
                highlightCpu.visible = false
            }
        }

        ListView.onAdd: SequentialAnimation {
            PropertyAction { target: cpuListItem; property: "height"; value: 0 }
            NumberAnimation { target: cpuListItem; property: "height"; to: 25; duration: 250; easing.type: Easing.InOutQuad }
        }
    }

}
