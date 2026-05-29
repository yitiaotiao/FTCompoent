import QtQuick
import "./Compoent"
import "./Demo"

Window {
    id: window
    width: 1600
    height: 960
    visible: true
    title: "FT's Compoent"

    FTRectangle{
        id:bg
        anchors.fill: parent
        color: "white"
    }

    FTRectangle{
        id:side
        width: parent.width * 0.3
        height: parent.height
        anchors.left: bg.left
        borderRightWidth: 1
        borderRightColor: "grey"
        Column{
            width: parent.width * 0.95
            height: parent.height * 0.8
            spacing: parent.height * 0.02
            anchors.centerIn: parent
            ExpandablePanel {
                id: demoPanel
                width: parent.width
                title: "Demo Item"
                FTButton{
                    width: parent.width
                    text: "NumberInputDemo"
                    onClicked: {
                        loader.source = "Demo/NumberInputDemo.qml"
                    }
                }
            }
            ExpandablePanel {
                id: compoentPanel
                width: parent.width
                title: "Compoent Item"
                FTButton{
                    width: parent.width
                    text: "Button"
                    onClicked: {
                        loader.sourceComponent = defaultLoader
                    }
                }
            }
        }
    }

    FTRectangle{
        width: parent.width * 0.7
        height: parent.height
        color: "transparent"
        anchors.right: bg.right
        Loader{
            id:loader
            anchors.centerIn: parent
            sourceComponent: defaultLoader
        }
    }

    Component{
        id:defaultLoader
        Image{
            anchors.centerIn: parent
            source: "Icon/main.png"
        }
    }


}
