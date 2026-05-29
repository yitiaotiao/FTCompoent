import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    property bool expanded: false

    property string title: "Panel"
    property color headerColor: "#ffffff"
    property color headerHoverColor: "#f3f4f6"
    property color contentColor: "transparent"
    property color dividerColor: "#e5e7eb"

    // expose corner radii and per-edge borders for header background (passed to FTRectangle)
    property real topLeftRadius: 8
    property real topRightRadius: 8
    property real bottomRightRadius: 8
    property real bottomLeftRadius: 8

    // default options (strings). If non-empty this repeater will be used.
    property var options: []
    // optional delegate for options
    property Component optionDelegate: null
    // delay (ms) before revealing content after expand starts
    property int revealDelay: 120

    width: parent ? parent.width : 300

    // expose default property so users can place custom content inside the panel
    default property alias content: contentColumn.data

    // header
    FTRectangle {
        id: headerBg
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 48
        color: headerColor
        topLeftRadius: root.topLeftRadius
        topRightRadius: root.topRightRadius
        bottomLeftRadius: root.bottomLeftRadius
        bottomRightRadius: root.bottomRightRadius

        // hover overlay
        Rectangle {
            anchors.fill: parent
            color: headerHoverColor
            opacity: parent.hoverProgress
            visible: parent.hoverProgress > 0.001
            radius: 0
            z: 1
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8
            z: 2

            Text {
                id: titleText
                text: root.title
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 16
                color: "#111827"
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            // chevron
            Rectangle {
                id: chevron
                width: 14; height: 14
                color: "transparent"
                border.width: 0
                Layout.alignment: Qt.AlignVCenter

                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d"); ctx.clearRect(0,0,width,height);
                        ctx.beginPath();
                        ctx.moveTo(width*0.2, height*0.3);
                        ctx.lineTo(width*0.8, height*0.5);
                        ctx.lineTo(width*0.2, height*0.7);
                        ctx.lineWidth = 2; ctx.strokeStyle = "#374151"; ctx.lineCap = 'round'; ctx.lineJoin='round'; ctx.stroke();
                    }
                }
                Rotation {
                    id: chevronRot
                    origin.x: chevron.width/2
                    origin.y: chevron.height/2
                    angle: root.expanded ? 90 : 0
                    Behavior on angle { NumberAnimation { duration: 220; easing.type: Easing.InOutQuad } }
                }
            }
        }

        MouseArea {
            id: headerMa
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.expanded = !root.expanded
            onEntered: {
                hoverAnim.to = 1
                hoverAnim.start()
            }
            onExited: {
                hoverAnim.to = 0
                hoverAnim.start()
            }
        }

        // hover progress used by overlay
        property real hoverProgress: 0
        NumberAnimation on hoverProgress { id: hoverAnim; duration: 180 }
    }

    // divider
    Rectangle {
        id: divider
        anchors.top: headerBg.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: dividerColor
        visible: contentContainer.height > 0
    }

    // content container with animated height and clipping
    Item {
        id: contentContainer
        anchors.top: headerBg.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        y: headerBg.height
        clip: true
        height: contentClipHeight

        property real contentClipHeight: 0

        Behavior on contentClipHeight { NumberAnimation { duration: 220; easing.type: Easing.InOutQuad } }

        Column {
            id: contentColumn
            width: parent.width
            spacing: 8
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 12
            opacity: root.expanded ? 1 : 0
        
            // options repeater (if options provided) - children created as part of this Column
            Component {
                id: defaultOpt
                Rectangle {
                    width: parent.width
                    height: 40
                    color: "transparent"
                    radius: 6
                    property real hoverP: 0
                    Layout.fillWidth: true

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        text: modelData
                        color: "#111827"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            hoverPAnim.to = 1
                            hoverPAnim.start()
                        }
                        onExited: {
                            hoverPAnim.to = 0
                            hoverPAnim.start()
                        }
                    }
                    NumberAnimation on hoverP { id: hoverPAnim; duration: 160 }

                    Rectangle { anchors.fill: parent; color: "#f8fafc"; opacity: hoverP*0.9; visible: opacity>0.001 }
                }
            }

            Repeater {
                id: optsRep
                model: root.options.length ? root.options : []
                delegate: root.optionDelegate ? root.optionDelegate : defaultOpt
            }
        }

        // opacity reveal animation for contained content
        NumberAnimation {
            id: contentOpacityAnim
            target: contentColumn
            property: "opacity"
            from: 0; to: 1
            duration: 160
            easing.type: Easing.InOutQuad
        }

        Timer {
            id: revealTimer
            interval: root.revealDelay
            repeat: false
            onTriggered: contentOpacityAnim.start()
        }

        // expose function to recalc content height
        function updateContentHeight() {
            // measure children total height
            var h = 0
            for (var i=0;i<contentColumn.children.length;i++) h += contentColumn.children[i].height + contentColumn.spacing
            if (h>0) h -= contentColumn.spacing
            // add vertical margins (12 top + 12 bottom)
            h += 24
            contentClipHeight = root.expanded ? h : 0
        }

        // watch children changes
        Connections {
            target: contentColumn
            function onChildrenChanged() { contentContainer.updateContentHeight() }
        }

        // react to expanded state change
        onVisibleChanged: contentContainer.updateContentHeight()
    }

    // (chevron rotation animation is handled on the Rotation.angle Behavior)

    // when expanded changes, update content height
    onExpandedChanged: {
        if (root.expanded) {
            // prepare hidden content, expand height, then reveal after delay
            contentColumn.opacity = 0
            Qt.callLater(function(){ contentContainer.updateContentHeight() })
            revealTimer.start()
        } else {
            // hide content immediately, then collapse height
            revealTimer.stop()
            contentOpacityAnim.stop()
            contentColumn.opacity = 0
            Qt.callLater(function(){ contentContainer.updateContentHeight() })
        }
    }

    // ensure the panel reports a correct implicitHeight so parent layouts move items below
    implicitHeight: headerBg.height + (contentContainer.contentClipHeight > 0 ? (contentContainer.contentClipHeight + (divider.visible ? divider.height : 0)) : 0)
    Behavior on implicitHeight { NumberAnimation { duration: 220; easing.type: Easing.InOutQuad } }

}
