import QtQuick 2.15

Item {
    id: root

    // Fill color for the custom rounded rectangle
    property color color: "transparent"
    property real radius: 0

    // Independent corner radii
    property real topLeftRadius: 0
    property real topRightRadius: 0
    property real bottomRightRadius: 0
    property real bottomLeftRadius: 0

    // Border appearance
    property real borderWidth: 0
    property color borderColor: "transparent"
    // Per-edge border widths (default to `borderWidth`)
    property real borderTopWidth: borderWidth
    property real borderRightWidth: borderWidth
    property real borderBottomWidth: borderWidth
    property real borderLeftWidth: borderWidth

    // Per-edge border colors (default to `borderColor`)
    property color borderTopColor: borderColor
    property color borderRightColor: borderColor
    property color borderBottomColor: borderColor
    property color borderLeftColor: borderColor

    implicitWidth: 100
    implicitHeight: 100

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var stroke = Math.max(0, borderWidth)
            var halfStroke = stroke / 2
            var drawWidth = Math.max(0, width - stroke)
            var drawHeight = Math.max(0, height - stroke)
            var x = halfStroke
            var y = halfStroke

            var tl = Math.max(0, topLeftRadius)
            var tr = Math.max(0, topRightRadius)
            var br = Math.max(0, bottomRightRadius)
            var bl = Math.max(0, bottomLeftRadius)
            var globalRadius = Math.max(0, radius)

            if (tl === 0) tl = globalRadius
            if (tr === 0) tr = globalRadius
            if (br === 0) br = globalRadius
            if (bl === 0) bl = globalRadius

            var maxRadius = Math.min(drawWidth, drawHeight) / 2
            tl = Math.min(tl, maxRadius)
            tr = Math.min(tr, maxRadius)
            br = Math.min(br, maxRadius)
            bl = Math.min(bl, maxRadius)

            ctx.beginPath()
            ctx.moveTo(x + tl, y)
            ctx.lineTo(x + drawWidth - tr, y)
            if (tr > 0) ctx.quadraticCurveTo(x + drawWidth, y, x + drawWidth, y + tr)
            else ctx.lineTo(x + drawWidth, y)
            ctx.lineTo(x + drawWidth, y + drawHeight - br)
            if (br > 0) ctx.quadraticCurveTo(x + drawWidth, y + drawHeight, x + drawWidth - br, y + drawHeight)
            else ctx.lineTo(x + drawWidth, y + drawHeight)
            ctx.lineTo(x + bl, y + drawHeight)
            if (bl > 0) ctx.quadraticCurveTo(x, y + drawHeight, x, y + drawHeight - bl)
            else ctx.lineTo(x, y + drawHeight)
            ctx.lineTo(x, y + tl)
            if (tl > 0) ctx.quadraticCurveTo(x, y, x + tl, y)
            else ctx.lineTo(x, y)
            ctx.closePath()

            if (color !== "transparent") {
                ctx.fillStyle = color
                ctx.fill()
            }

            // Draw per-edge borders (simple stroked center-lines).
            // Edges may overlap; draw order is top -> right -> bottom -> left.
            ctx.lineJoin = "round"
            ctx.lineCap = "round"

            // Top edge
            var tw = Math.max(0, borderTopWidth)
            if (tw > 0 && borderTopColor !== "transparent") {
                ctx.beginPath()
                ctx.moveTo(x + tl, y + tw/2)
                ctx.lineTo(x + drawWidth - tr, y + tw/2)
                ctx.lineWidth = tw
                ctx.strokeStyle = borderTopColor
                ctx.stroke()
            }

            // Right edge
            var rw = Math.max(0, borderRightWidth)
            if (rw > 0 && borderRightColor !== "transparent") {
                ctx.beginPath()
                ctx.moveTo(x + drawWidth - rw/2, y + tr)
                ctx.lineTo(x + drawWidth - rw/2, y + drawHeight - br)
                ctx.lineWidth = rw
                ctx.strokeStyle = borderRightColor
                ctx.stroke()
            }

            // Bottom edge
            var bw = Math.max(0, borderBottomWidth)
            if (bw > 0 && borderBottomColor !== "transparent") {
                ctx.beginPath()
                ctx.moveTo(x + drawWidth - br, y + drawHeight - bw/2)
                ctx.lineTo(x + bl, y + drawHeight - bw/2)
                ctx.lineWidth = bw
                ctx.strokeStyle = borderBottomColor
                ctx.stroke()
            }

            // Left edge
            var lw = Math.max(0, borderLeftWidth)
            if (lw > 0 && borderLeftColor !== "transparent") {
                ctx.beginPath()
                ctx.moveTo(x + lw/2, y + drawHeight - bl)
                ctx.lineTo(x + lw/2, y + tl)
                ctx.lineWidth = lw
                ctx.strokeStyle = borderLeftColor
                ctx.stroke()
            }
        }

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onAntialiasingChanged: requestPaint()
    }

    onColorChanged: canvas.requestPaint()
    onRadiusChanged: canvas.requestPaint()
    onTopLeftRadiusChanged: canvas.requestPaint()
    onTopRightRadiusChanged: canvas.requestPaint()
    onBottomRightRadiusChanged: canvas.requestPaint()
    onBottomLeftRadiusChanged: canvas.requestPaint()
    onBorderWidthChanged: canvas.requestPaint()
    onBorderColorChanged: canvas.requestPaint()
}

