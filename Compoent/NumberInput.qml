import QtQuick 2.15

Item {
    id:root
    property bool isSelected: false
    property string bgColor: isSelected ? "#B63A3D" : "#FFFFFF"
    property string textColor: isSelected ? "#FFFFFE" : "#879392"
    property string numColor: isSelected ? "#FFFFFE" : "#302F35"
    property int value: 0

    signal select()
    signal unSelect()
    signal selectMinusIcon()
    signal selectAddIcon()

    implicitWidth: 100
    implicitHeight: 40

    onSelect: {
        isSelected = true
    }

    onUnSelect: {
        isSelected = false
    }

    FTRectangle{
        id:bg
        color: bgColor
        anchors.fill: parent
        topLeftRadius: 10
        topRightRadius: 5
        bottomLeftRadius: 5
        bottomRightRadius: 10
    }

    MouseArea{
        id:rootMA
        anchors.fill: parent
        onClicked: {
            select()
        }
    }

    FTRectangle{
        width: parent.width / 3
        height: parent.height
        color: "transparent"
        borderRightColor: textColor
        borderRightWidth: 1
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        Text {
            id: minusIcon
            anchors.fill: parent
            text: "-"
            font.pixelSize: parent.height * 0.5
            font.bold: true
            color: textColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(value > 0){
                    value--
                }else{
                    value = 0
                }
                select()
            }
        }
    }

    FTRectangle{
        width: parent.width / 3
        height: parent.height
        color: "transparent"
        borderRightColor: textColor
        borderRightWidth: 1
        borderLeftColor: textColor
        borderLeftWidth: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Text {
            id: numValue
            anchors.fill: parent
            text: value
            font.pixelSize: parent.height * 0.5
            font.bold: true
            color: numColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    FTRectangle{
        width: parent.width / 3
        height: parent.height
        color: "transparent"
        borderLeftColor: textColor
        borderLeftWidth: 1
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        Text {
            id: addIcon
            anchors.fill: parent
            text: "+"
            font.pixelSize: parent.height * 0.5
            font.bold: true
            color: textColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                value++
                select()
            }
        }
    }

}
