---
name: metal-swift-ios
description: Expert workflows for 3D graphics on iOS with Metal and Swift. Use for pipeline setup, MSL shaders, and SIMD transformations.
---

# Metal + Swift iOS Graphics

## Quick Start: The "Hello Triangle" Pattern
1. **Renderer:** Create a class implementing `MTKViewDelegate`.
2. **Pipeline:** Initialize `MTLRenderPipelineState` once.
3. **Shaders:** Use `vertexMain` and `fragmentMain` in `.metal` files.
4. **SwiftUI:** Wrap `MTKView` using `NSViewRepresentable` (macOS) or `UIViewRepresentable` (iOS).

## Best Practices
- **Memory:** Use `.storageModeShared` for CPU-to-GPU data transfer.
- **Commands:** Minimize `MTLRenderCommandEncoder` calls; batch draw calls where possible.
- **Shaders:** Prefer `half` precision for colors/normals to optimize bandwidth.

## Resources
- [references/math.md](references/math.md) - SIMD Matrix & Vector utilities.
- [references/shaders.md](references/shaders.md) - Boilerplate MSL code.
- [references/hello-world.md](references/hello-world.md) - Minimal working example.
