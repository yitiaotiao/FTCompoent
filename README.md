# FTCompoent

FTCompoent is a custom QML component library for Qt 6, including several demo to showcase component usage（Pending update）.

## Features
- Custom reusable QML components
- Example demo programs for quick start
- Modular structure for easy extension

## Requirements
- Qt 6.x (Tested with Qt 6.11.1)
- CMake (for building C++/QML projects)

## Getting Started

### Build Instructions
1. Clone this repository:
   ```sh
   git clone <your-repo-url>
   cd FTCompoent
   ```
2. Configure the project with CMake:
   ```sh
   cmake -B build -S .
   ```
3. Build the project:
   ```sh
   cmake --build build
   ```
4. Run the demo application:
   - The executable will be located in the `build` directory (e.g., `build/your_executable_name`).

### Using Components
- QML components are located in the `Compoent/` and `Icon/` directories.
- You can import and use them in your own QML projects.

## Project Structure
- `Compoent/` - Custom QML components
- `Icon/` - Icon resources
- `Main.qml` - Main entry QML file for demo
- `main.cpp` - C++ entry point
- `CMakeLists.txt` - Build configuration

## Author
枫糖 (FengTang)

## License
GNU General Public License v3.0
