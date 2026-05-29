import QtQuick 2.15

Item {
	id: root
	width: 140
	height: 40

	signal clicked()

	// Text / style
	property string text: "Button"
	property color backgroundColor: "#3b82f6"
	property color hoverColor: "#60a5fa"
	property color pressedColor: "#1e40af"
	property color textColor: "white"
	property alias font: label.font
	property int padding: 12

	// Per-corner radius (can set any single corner)
	property real topLeftRadius: 8
	property real topRightRadius: 8
	property real bottomRightRadius: 8
	property real bottomLeftRadius: 8

	// Per-edge border widths and colors (customize any single edge)
	property real borderTopWidth: 0
	property real borderRightWidth: 0
	property real borderBottomWidth: 0
	property real borderLeftWidth: 0
	property color borderTopColor: "transparent"
	property color borderRightColor: "transparent"
	property color borderBottomColor: "transparent"
	property color borderLeftColor: "transparent"

	// Interaction progress values used for animation (0..1)
	property real hoverProgress: 0
	property real pressProgress: 0

	// ripple state
	property real rippleX: width/2
	property real rippleY: height/2
	property real rippleRadius: 0

	Canvas {
		id: canvas
		anchors.fill: parent
		onPaint: {
			var ctx = getContext("2d");
			ctx.clearRect(0,0,width,height);

			var x = 0.5; // sub-pixel to make 1px lines crisper
			var y = 0.5;
			var w = Math.max(0, width-1);
			var h = Math.max(0, height-1);

			function roundedRectPath(x,y,w,h,tl,tr,br,bl) {
				ctx.beginPath();
				ctx.moveTo(x + tl, y);
				ctx.lineTo(x + w - tr, y);
				if (tr>0) ctx.quadraticCurveTo(x + w, y, x + w, y + tr);
				else ctx.lineTo(x + w, y);
				ctx.lineTo(x + w, y + h - br);
				if (br>0) ctx.quadraticCurveTo(x + w, y + h, x + w - br, y + h);
				else ctx.lineTo(x + w, y + h);
				ctx.lineTo(x + bl, y + h);
				if (bl>0) ctx.quadraticCurveTo(x, y + h, x, y + h - bl);
				else ctx.lineTo(x, y + h);
				ctx.lineTo(x, y + tl);
				if (tl>0) ctx.quadraticCurveTo(x, y, x + tl, y);
				else ctx.lineTo(x, y);
				ctx.closePath();
			}

			// Fill base
			roundedRectPath(x,y,w,h, root.topLeftRadius, root.topRightRadius, root.bottomRightRadius, root.bottomLeftRadius);
			ctx.fillStyle = root.backgroundColor;
			ctx.fill();

			// Hover overlay
			if (root.hoverProgress > 0.0001) {
				ctx.save();
				ctx.globalAlpha = Math.min(1, root.hoverProgress * 0.7);
				roundedRectPath(x,y,w,h, root.topLeftRadius, root.topRightRadius, root.bottomRightRadius, root.bottomLeftRadius);
				ctx.fillStyle = root.hoverColor;
				ctx.fill();
				ctx.restore();
			}

			// Press overlay (stronger)
			if (root.pressProgress > 0.0001) {
				ctx.save();
				ctx.globalAlpha = Math.min(1, root.pressProgress * 0.8);
				roundedRectPath(x,y,w,h, root.topLeftRadius, root.topRightRadius, root.bottomRightRadius, root.bottomLeftRadius);
				ctx.fillStyle = root.pressedColor;
				ctx.fill();
				ctx.restore();
			}

			// Draw per-edge borders (stroke along each edge)
			ctx.lineJoin = 'round';
			ctx.lineCap = 'butt';

			// top
			if (root.borderTopWidth > 0) {
				ctx.beginPath();
				ctx.moveTo(x + root.topLeftRadius, y);
				ctx.lineTo(x + w - root.topRightRadius, y);
				ctx.strokeStyle = root.borderTopColor;
				ctx.lineWidth = root.borderTopWidth;
				ctx.stroke();
			}
			// right
			if (root.borderRightWidth > 0) {
				ctx.beginPath();
				ctx.moveTo(x + w, y + root.topRightRadius);
				ctx.lineTo(x + w, y + h - root.bottomRightRadius);
				ctx.strokeStyle = root.borderRightColor;
				ctx.lineWidth = root.borderRightWidth;
				ctx.stroke();
			}
			// bottom
			if (root.borderBottomWidth > 0) {
				ctx.beginPath();
				ctx.moveTo(x + w - root.bottomRightRadius, y + h);
				ctx.lineTo(x + root.bottomLeftRadius, y + h);
				ctx.strokeStyle = root.borderBottomColor;
				ctx.lineWidth = root.borderBottomWidth;
				ctx.stroke();
			}
			// left
			if (root.borderLeftWidth > 0) {
				ctx.beginPath();
				ctx.moveTo(x, y + h - root.bottomLeftRadius);
				ctx.lineTo(x, y + root.topLeftRadius);
				ctx.strokeStyle = root.borderLeftColor;
				ctx.lineWidth = root.borderLeftWidth;
				ctx.stroke();
			}

			// ripple (simple circle) drawn above fills and below text
			if (ripple.opacity > 0.001) {
				ctx.save();
				ctx.globalAlpha = ripple.opacity;
				ctx.beginPath();
				ctx.arc(root.rippleX, root.rippleY, root.rippleRadius, 0, Math.PI * 2);
				ctx.fillStyle = root.pressedColor;
				ctx.fill();
				ctx.restore();
			}
		}
	}

	// text label
	Text {
		id: label
		anchors.centerIn: parent
		text: root.text
		color: root.textColor
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		elide: Text.ElideRight
	}

	// invisible element used for ripple animation state (exposed to Canvas)
	QtObject {
		id: ripple
		property real opacity: 0
	}

	MouseArea {
		id: ma
		anchors.fill: parent
		hoverEnabled: true
		onEntered: {
			hoverAnim.to = 1
			hoverAnim.start()
		}
		onExited: {
			hoverAnim.to = 0
			hoverAnim.start()
		}
		onPressed: function(mouse) {
			root.rippleX = mouse.x; root.rippleY = mouse.y;
			rippleAnim.restart();
			pressAnim.to = 1; pressAnim.start();
		}
		onReleased: {
			pressAnim.to = 0; pressAnim.start();
		}
		onClicked: root.clicked()
	}

	// Hover animation
	NumberAnimation on hoverProgress { id: hoverAnim; duration: 180 }
	// Press animation (color overlay intensity)
	NumberAnimation on pressProgress { id: pressAnim; duration: 120 }

	// Ripple animation: animate ripple.opacity and rippleRadius via sequential animations
	SequentialAnimation {
		id: rippleAnim
		PropertyAction { target: ripple; property: 'opacity'; value: 0.5 }
		ParallelAnimation {
			NumberAnimation { target: ripple; property: 'opacity'; from: 0.5; to: 0.0; duration: 400 }
			ScriptAction {
				script: {
					// animate radius using a timer-based approach by updating root.rippleRadius and requesting paint
					var start = Date.now();
					var duration = 400;
					var maxR = Math.max(root.width, root.height) * 1.2;
					var t = function() {
						var p = (Date.now() - start) / duration;
						if (p >= 1) { root.rippleRadius = maxR; ripple.opacity = 0; canvas.requestPaint(); return; }
						root.rippleRadius = p * maxR;
						ripple.opacity = 0.5 * (1 - p);
						canvas.requestPaint();
						Qt.callLater(t);
					};
					t();
				}
			}
		}
	}

	// update canvas when relevant properties change
	onWidthChanged: canvas.requestPaint()
	onHeightChanged: canvas.requestPaint()
	onTopLeftRadiusChanged: canvas.requestPaint()
	onTopRightRadiusChanged: canvas.requestPaint()
	onBottomRightRadiusChanged: canvas.requestPaint()
	onBottomLeftRadiusChanged: canvas.requestPaint()
	onBackgroundColorChanged: canvas.requestPaint()
	onHoverColorChanged: canvas.requestPaint()
	onPressedColorChanged: canvas.requestPaint()
	onBorderTopWidthChanged: canvas.requestPaint()
	onBorderRightWidthChanged: canvas.requestPaint()
	onBorderBottomWidthChanged: canvas.requestPaint()
	onBorderLeftWidthChanged: canvas.requestPaint()

	// keep canvas repainted when hover/press changes (handled via on*Changed handlers)

	// ensure canvas repaints at least once when animations change
	onHoverProgressChanged: canvas.requestPaint()
	onPressProgressChanged: canvas.requestPaint()

}
