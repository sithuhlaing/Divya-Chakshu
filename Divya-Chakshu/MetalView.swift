import SwiftUI
import MetalKit

struct MetalView: NSViewRepresentable {
    @Binding var rotation: SIMD2<Float>

    func makeNSView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        mtkView.delegate = context.coordinator
        return mtkView
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        context.coordinator.renderer?.rotation = rotation
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MTKViewDelegate {
        var parent: MetalView
        var renderer: Renderer?

        init(_ parent: MetalView) {
            self.parent = parent
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            if renderer == nil { 
                renderer = Renderer(metalKitView: view)
                renderer?.rotation = parent.rotation
            }
            renderer?.mtkView(view, drawableSizeWillChange: size)
        }

        func draw(in view: MTKView) {
            renderer?.draw(in: view)
        }
    }
}
