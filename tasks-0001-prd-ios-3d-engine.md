## Relevant Files

- `Divya-Chakshu/Renderer.swift` - Contains the core Metal rendering logic, needs expansion for 3D engine
- `Divya-Chakshu/Renderer.swift.test` - Unit tests for Renderer class
- `Divya-Chakshu/MetalView.swift` - SwiftUI wrapper for MTKView, needs enhancement for 3D capabilities
- `Divya-Chakshu/MetalView.swift.test` - Unit tests for MetalView wrapper
- `Divya-Chakshu/Shader.metal` - Metal shaders, needs expansion for 3D transformations and lighting
- `Divya-Chakshu/Shader.metal.test` - Shader compilation and functionality tests
- `Divya-Chakshu/Engine/` - New directory for core engine components
- `Divya-Chakshu/Engine/Scene.swift` - Scene management system
- `Divya-Chakshu/Engine/Scene.swift.test` - Scene management tests
- `Divya-Chakshu/Engine/Camera.swift` - Camera system with perspective projection
- `Divya-Chakshu/Engine/Camera.swift.test` - Camera functionality tests
- `Divya-Chakshu/Engine/Mesh.swift` - 3D mesh and primitive generation
- `Divya-Chakshu/Engine/Mesh.swift.test` - Mesh generation tests
- `Divya-Chakshu/Engine/Transform.swift` - 3D transformation matrices
- `Divya-Chakshu/Engine/Transform.swift.test` - Transform calculations tests
- `Divya-Chakshu/Engine/Light.swift` - Lighting system components
- `Divya-Chakshu/Engine/Light.swift.test` - Lighting calculations tests
- `Divya-Chakshu/Engine/Material.swift` - Material and shader management
- `Divya-Chakshu/Engine/Material.swift.test` - Material system tests
- `Divya-Chakshu/Engine/PerformanceMonitor.swift` - Frame rate and performance metrics
- `Divya-Chakshu/Engine/PerformanceMonitor.swift.test` - Performance monitoring tests
- `Divya-Chakshu/Utils/Math.swift` - Mathematical utilities for 3D operations
- `Divya-Chakshu/Utils/Math.swift.test` - Math utility tests

### Notes

- Unit tests should typically be placed alongside the code files they are testing (e.g., `Renderer.swift` and `Renderer.test.swift` in the same directory).
- Use `xcodebuild test -scheme Divya-Chakshu` to run tests. Running without a path executes all tests found in the project.
- The existing codebase already has basic Metal setup with triangle rendering, which serves as a foundation for the 3D engine.

## Tasks

- [ ] 1.0 Core 3D Engine Architecture
- [ ] 2.0 3D Rendering Pipeline Enhancement
- [ ] 3.0 Shader Management System
- [ ] 4.0 Performance Optimization Framework
- [ ] 5.0 Testing and Documentation
