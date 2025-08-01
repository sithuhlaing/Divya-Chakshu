// MARK: - Renderer.swift
// Create this new file in your project.
// This class contains the core Metal rendering logic, similar to the previous version.

import MetalKit

class Renderer: NSObject {

    // MARK: - Properties

    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    var pipelineState: MTLRenderPipelineState
    var vertexBuffer: MTLBuffer

    // MARK: - Initialization

    init?(metalKitView: MTKView) {
        guard let device = metalKitView.device else { return nil }
        self.device = device
        
        guard let commandQueue = device.makeCommandQueue() else { return nil }
        self.commandQueue = commandQueue

        // Define the vertices of our triangle.
        struct Vertex {
            var position: SIMD3<Float>
            var color: SIMD4<Float>
        }

        let vertices: [Vertex] = [
            Vertex(position: SIMD3<Float>(-0.8, -0.8, 0.0), color: SIMD4<Float>(1.0, 0.0, 0.0, 1.0)), // Bottom-left, Red
            Vertex(position: SIMD3<Float>( 0.8, -0.8, 0.0), color: SIMD4<Float>(0.0, 1.0, 0.0, 1.0)), // Bottom-right, Green
            Vertex(position: SIMD3<Float>( 0.0,  0.8, 0.0), color: SIMD4<Float>(0.0, 0.0, 1.0, 1.0))  // Top-center, Blue
        ]

        guard let vertexBuffer = device.makeBuffer(bytes: vertices,
                                                   length: MemoryLayout<Vertex>.stride * vertices.count,
                                                   options: .storageModeShared) else { return nil }
        self.vertexBuffer = vertexBuffer

        guard let defaultLibrary = device.makeDefaultLibrary() else { return nil }
        guard let vertexFunction = defaultLibrary.makeFunction(name: "vertexShader") else { return nil }
        guard let fragmentFunction = defaultLibrary.makeFunction(name: "fragmentShader") else { return nil }

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print("Failed to create render pipeline state: \(error)")
            return nil
        }

        super.init()
    }

    // MARK: - MTKViewDelegate Methods

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("MTKView size changed to: \(size.width)x\(size.height)")
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else { return }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        commandBuffer.label = "MyFirstMetalCommand"

        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        renderEncoder.label = "MyFirstMetalEncoder"

        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
