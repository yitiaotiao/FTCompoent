import QtQuick
import "./Compoent"

Window {
    id: window
    width: 1024
    height: 600
    visible: true
    title: "FT's Compoent"

    FontLoader {
        id: iconFont
        source: "Icon/iconfont.ttf"
    }

    FTRectangle{
        id: bg
        width: 800
        height: 400
        color: "#A9ADB0"
        anchors.centerIn: parent

        FTRectangle{
            id: settingIcon
            width: parent.width * 0.1
            height: parent.height * 0.12
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: "black"
            bottomLeftRadius: 10
            bottomRightRadius: 10

            Text {
                anchors.centerIn: parent
                text: "\ue851"
                font.family: iconFont.name
                font.pixelSize: settingIcon.height * 0.6
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Row{
            id: iconRow
            width: parent.width * 0.2
            height: settingIcon.height
            spacing: width * 0.02
            anchors.right: parent.right
            anchors.rightMargin: iconRow.spacing

            Repeater{
                model: [{text:"\ue683",color:"red"},{text:"\ue682",color:"blue"},{text:"\ue8c1",color:"white"}]
                Text {
                    width: (iconRow.width - (iconRow.spacing * 2)) / 3
                    height: iconRow.height
                    text: modelData.text
                    font.family: iconFont.name
                    font.pixelSize: settingIcon.height * 0.8
                    color: modelData.color
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Grid{
            id:grid
            rows: 2
            spacing: bg.width * 0.02
            width: parent.width * 0.94
            height: parent.height * 0.8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.16
            Repeater{
                model: 4
                NumberInput{
                    width: (grid.width - grid.spacing) / 2
                    height: (grid.height - grid.spacing) / 2

                    onSelect: {
                        grid.selectNumberInput(index)
                    }
                }
            }

            function selectNumberInput(idx){
                for(var i = 0; i < children.length; i++){
                    var child = children[i]
                    if(child && typeof child.isSelected !== "undefined"){
                        child.isSelected = (i === idx)
                    }
                }
            }
        }
    }
}
