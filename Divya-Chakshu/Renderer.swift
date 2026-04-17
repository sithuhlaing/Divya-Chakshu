import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    var rotation = SIMD2<Float>(0, 0)

    struct Vertex {
        var position: SIMD3<Float>
        var color: SIMD4<Float>
    }

    init?(metalKitView: MTKView) {
        guard let device = metalKitView.device,
              let commandQueue = device.makeCommandQueue() else { return nil }
        self.device = device
        self.commandQueue = commandQueue

        let white = SIMD4<Float>(1, 1, 1, 1)
        let vertices = [
            Vertex(position: [-0.5, -0.5,  0.5], color: white), // 0
            Vertex(position: [ 0.5, -0.5,  0.5], color: white), // 1
            Vertex(position: [ 0.5,  0.5,  0.5], color: white), // 2
            Vertex(position: [-0.5,  0.5,  0.5], color: white), // 3
            Vertex(position: [-0.5, -0.5, -0.5], color: white), // 4
            Vertex(position: [ 0.5, -0.5, -0.5], color: white), // 5
            Vertex(position: [ 0.5,  0.5, -0.5], color: white), // 6
            Vertex(position: [-0.5,  0.5, -0.5], color: white)  // 7
        ]

        let indices: [UInt16] = [
            0, 1, 1, 2, 2, 3, 3, 0, // Front face
            4, 5, 5, 6, 6, 7, 7, 4, // Back face
            0, 4, 1, 5, 2, 6, 3, 7  // Connections
        ]

        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: MemoryLayout<Vertex>.stride * vertices.count,
                                         options: .storageModeShared)!
        
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: MemoryLayout<UInt16>.stride * indices.count,
                                        options: .storageModeShared)!

        let library = device.makeDefaultLibrary()!
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = 16
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertexMain")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragmentMain")
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat

        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        super.init()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }

        // Rotation from pointer
        let cosX = cos(rotation.x)
        let sinX = sin(rotation.x)
        let cosY = cos(rotation.y)
        let sinY = sin(rotation.y)
        
        let rotationY = simd_float4x4(
            SIMD4<Float>(cosY, 0, -sinY, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(sinY, 0, cosY, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
        
        let rotationX = simd_float4x4(
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, cosX, sinX, 0),
            SIMD4<Float>(0, -sinX, cosX, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
        
        // Perspective Projection
        let aspect = Float(view.drawableSize.width / view.drawableSize.height)
        let fov = Float.pi / 3.0
        let near: Float = 0.1
        let far: Float = 100.0
        let f = 1.0 / tan(fov / 2.0)
        
        let projectionMatrix = simd_float4x4(
            SIMD4<Float>(f / aspect, 0, 0, 0),
            SIMD4<Float>(0, f, 0, 0),
            SIMD4<Float>(0, 0, far / (far - near), 1),
            SIMD4<Float>(0, 0, -(far * near) / (far - near), 0)
        )
        
        // Model-View-Projection Matrix
        let translation = simd_float4x4(
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),
            SIMD4<Float>(0, 0, 2, 1) // Move back 2 units
        )
        
        let modelMatrix = rotationX * rotationY
        let mvpMatrix = projectionMatrix * translation * modelMatrix

        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setVertexBytes([mvpMatrix], length: MemoryLayout<simd_float4x4>.stride, index: 1)
        
        encoder.drawIndexedPrimitives(type: .line,
                                      indexCount: 24,
                                      indexType: .uint16,
                                      indexBuffer: indexBuffer,
                                      indexBufferOffset: 0)
        
        encoder.endEncoding()

        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
}
