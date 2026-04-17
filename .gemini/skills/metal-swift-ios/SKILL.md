---
name: metal-swift-ios
description: Specialized workflows for developing high-performance 3D graphics on iOS using Metal and Swift. Use this skill when implementing rendering pipelines, writing Metal Shading Language (MSL) shaders, or performing 3D coordinate transformations for iOS applications.
---

# Metal and Swift for iOS 3D Graphics

This skill provides expert procedural guidance for building 3D engines and applications on iOS using the Metal framework.

## Core Workflows

### 1. Metal Pipeline Configuration
- **Device & Queue:** Always check for `MTLDevice` availability before initializing `MTLCommandQueue`.
- **Render Pipeline State:** Cache `MTLRenderPipelineState` objects; avoid creating them during the render loop.
- **Resource Management:** Use `MTLBuffer` for vertex/index data. Prefer `.storageModeShared` for data frequently updated by the CPU and `.storageModePrivate` for static GPU-only data.

### 2. Shader Development (MSL)
- **Vertex Shaders:** Focus on vertex transformations (Model-View-Projection). Use `[[stage_in]]` for vertex attributes.
- **Fragment Shaders:** Handle lighting and material calculations. Always consider performance impacts of complex branching.
- **Types:** Use `float4` for positions and colors. Use `half` precision where full `float` is not required to save bandwidth.

### 3. 3D Mathematics (SIMD)
- **Coordinate System:** Metal uses a Normalized Device Coordinate (NDC) system where Z ranges from 0.0 to 1.0 (right-handed).
- **Matrices:** 
    - **Model Matrix:** Local space to World space.
    - **View Matrix:** World space to Camera space.
    - **Projection Matrix:** Camera space to NDC.
- **Library:** Use the Swift `simd` library for performant vector and matrix operations.

## Project-Specific Guidelines (Divya-Chakshu)
- **Renderer Class:** Centralize all Metal logic in the `Renderer` class.
- **MetalView:** Use the `MTKView` delegate pattern for frame updates.
- **Shader Organization:** Keep MSL code in `.metal` files; use descriptive function names like `vertexMain` and `fragmentMain`.

## Common Issues & Solutions
- **Vertex Descriptor Error:** If you get "Vertex function has input attributes but no vertex descriptor was set", ensure you have created a `MTLVertexDescriptor` that matches your shader's `[[attribute(n)]]` and assigned it to `pipelineDescriptor.vertexDescriptor`.
- **Rotation/Transformation:** Pass transformation matrices as uniforms using `setVertexBytes` or `setVertexBuffer` at a specific index (e.g., `[[buffer(1)]]`) and multiply the position in the vertex shader.

## Resources
- **Math Reference:** See [references/math.md](references/math.md) for matrix formulas.
- **Shader Snippets:** See [references/shaders.md](references/shaders.md) for common lighting models.
- **Asset Templates:** See [assets/primitives/](assets/primitives/) for base 3D vertex data.
