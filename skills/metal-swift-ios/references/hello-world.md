# Minimal Metal "Hello World" (Triangle)

## 1. Swift Renderer
```swift
class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let queue: MTLCommandQueue
    let pso: MTLRenderPipelineState
    let buffer: MTLBuffer

    init?(mtkView: MTKView) {
        self.device = mtkView.device!
        self.queue = device.makeCommandQueue()!
        
        let vertices: [SIMD3<Float>] = [[0, 0.5, 0], [-0.5, -0.5, 0], [0.5, -0.5, 0]]
        self.buffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<SIMD3<Float>>.stride * 3, options: [])!

        let library = device.makeDefaultLibrary()!
        let desc = MTLRenderPipelineDescriptor()
        desc.vertexFunction = library.makeFunction(name: "vertexMain")
        desc.fragmentFunction = library.makeFunction(name: "fragmentMain")
        desc.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        self.pso = try! device.makeRenderPipelineState(descriptor: desc)
    }

    func draw(in view: MTKView) {
        let cmdbuf = queue.makeCommandBuffer()!
        let encoder = cmdbuf.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)!
        encoder.setRenderPipelineState(pso)
        encoder.setVertexBuffer(buffer, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        encoder.endEncoding()
        cmdbuf.present(view.currentDrawable!)
        cmdbuf.commit()
    }
}
```

## 2. MSL Shader
```metal
#include <metal_stdlib>
using namespace metal;

vertex float4 vertexMain(device float3 *pos [[buffer(0)]], uint id [[vertex_id]]) {
    return float4(pos[id], 1.0);
}

fragment float4 fragmentMain() {
    return float4(1, 0, 0, 1); // Red
}
```
