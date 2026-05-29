# FTCompoent

FTCompoent is a small collection of custom QML components and demo applications for Qt 6. It provides reusable UI building blocks and example integrations to help you prototype and ship QML features faster.

<img width="2000" height="1238" alt="image" src="https://github.com/user-attachments/assets/0c4922c3-465f-4a93-b235-16bf45807aa5" />

<img width="2000" height="1238" alt="image" src="https://github.com/user-attachments/assets/240048a6-d4f5-499d-aa59-194daa1391c7" />

## Features

- Reusable QML components for common UI patterns
- Ready-to-run demo applications for quick experimentation
- Modular layout that makes it easy to extend or adapt components

## Requirements

- Qt 6.x (tested with Qt 6.11.1)
- CMake (for building the native project)

## Getting Started

### Build

1. Clone the repository:

```sh
git clone <your-repo-url>
cd simpleCompoent
```

2. Configure with CMake:

```sh
cmake -B build -S .
```

3. Build the project:

```sh
cmake --build build
```

4. Run the demo executable from the `build` directory (the exact path depends on your platform and CMake configuration).

### Using the components

- QML components live in the `Compoent/` directory and icons are under `Icon/`.
- Import the components into your QML file using a relative import or by registering the module in C++.

Example (relative import):

```qml
import QtQuick 2.15
import "./Compoent"

ExpandablePanel {
    width: parent.width
    title: "Settings"
    options: ["Option A", "Option B", "Option C"]
    revealDelay: 150

    // Custom content can also be provided
    Rectangle { width: parent.width; height: 60; color: "transparent";
        Text { anchors.centerIn: parent; text: "Custom content example" }
    }
}
```

## Component spotlight — ExpandablePanel

`ExpandablePanel` is a collapsible panel with a header and optional content. It includes expand/collapse animations and hover effects to match modern UI patterns.

Main properties

- `title`: Header text
- `expanded`: Boolean controlling the panel state
- `options`: Array of strings used to populate a simple option list
- `optionDelegate`: `Component` used to customize how each option is rendered
- Corner radii: `topLeftRadius`, `topRightRadius`, `bottomRightRadius`, `bottomLeftRadius`
- `revealDelay`: Delay in milliseconds before inner content fades in after expansion (default: 120)

Behavior

- On expand: the panel grows vertically, then the inner content fades in after `revealDelay` to avoid clipping.
- On collapse: inner content is hidden before the panel collapses.

## Component spotlight — FTButton

`FTButton` is a highly customizable button implemented with a `Canvas` for pixel-perfect rendering. It supports hover/press overlays, a ripple effect, per-corner radii and per-edge borders.

Main properties

- `text`, `textColor` — label and color
- `backgroundColor`, `hoverColor`, `pressedColor` — base and interaction colors
- `padding`, `font` — layout and typography
- Corner radii: `topLeftRadius`, `topRightRadius`, `bottomRightRadius`, `bottomLeftRadius`
- Per-edge borders: `borderTopWidth`, `borderTopColor`, `borderRightWidth`, `borderRightColor`, `borderBottomWidth`, `borderBottomColor`, `borderLeftWidth`, `borderLeftColor`
- Signals: `clicked()` — emitted when the button is clicked

Usage example

```qml
import QtQuick 2.15
import "./Compoent"

FTButton {
    width: 120
    text: "OK"
    backgroundColor: "#10b981"
    hoverColor: "#34d399"
    pressedColor: "#047857"
    onClicked: console.log("FTButton clicked")
}
```

## Component spotlight — FTRectangle

`FTRectangle` renders a rounded rectangle with optional per-corner radii and per-edge borders. It's useful as a lightweight, stylable background primitive.

Main properties

- `color` — fill color
- `radius` — global corner radius fallback
- Per-corner radii: `topLeftRadius`, `topRightRadius`, `bottomRightRadius`, `bottomLeftRadius`
- Border: `borderWidth`, `borderColor`, and per-edge overrides `borderTopWidth`, `borderTopColor`, etc.

Usage example

```qml
FTRectangle {
    width: 200; height: 56
    color: "#ffffff"
    radius: 10
    borderWidth: 1
    borderColor: "#e5e7eb"
}
```

## Component spotlight — NumberInput

`NumberInput` is a compact control for displaying and editing an integer value with minus and plus zones. It composes `FTRectangle` pieces and exposes selection signals.

Main properties & signals

- `value` (int) — current numeric value
- `isSelected` (bool) — selection state
- `bgColor`, `textColor`, `numColor` — appearance toggles based on selection
- Signals: `select()`, `unSelect()`, `selectMinusIcon()`, `selectAddIcon()`

Usage example

```qml
NumberInput {
    width: 180
    value: 2
    onSelect: console.log("selected")
}
```

## Project layout

- `Compoent/` — QML components
- `Demo/` — Demo QML files (examples)
- `Icon/` — Icon assets
- `Main.qml` — Demo application entry QML
- `main.cpp` — Native application entry point
- `CMakeLists.txt` — Build configuration

## Contributing

Contributions, bug reports and feature requests are welcome. Please open issues or pull requests on the repository. Include a short description of the change, steps to reproduce (if applicable), and any screenshots that help illustrate the issue.

## Author

Feng Tang (枫糖)

## License

This project is licensed under the GNU General Public License v3.0.
