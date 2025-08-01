//
//  MetalView.swift
//  Divya-Chakshu
//
//  Created by Si Thu Hlaing on 25.07.25.
//

import SwiftUI
import MetalKit

// NSViewRepresentable is used to wrap an NSView (like MTKView) for use in SwiftUI.
struct MetalView: NSViewRepresentable {
    // The MTKView instance that will display our Metal content.
    let mtkView = MTKView()

    // MARK: - Coordinator Class
        // The Coordinator acts as the delegate for MTKView and holds the Renderer.
        class Coordinator: NSObject, MTKViewDelegate {
            var renderer: Renderer?
            let mtkView: MTKView // Hold a reference to the MTKView

            init(mtkView: MTKView) {
                self.mtkView = mtkView
                super.init()
                // Initialize the renderer here, passing the MTKView
                self.renderer = Renderer(metalKitView: mtkView)
            }

            // MTKViewDelegate method: Called when the MTKView's size changes.
            func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
                // Forward the call to our renderer.
                renderer?.mtkView(view, drawableSizeWillChange: size)
            }

            // MTKViewDelegate method: Called when the MTKView needs to draw a new frame.
            func draw(in view: MTKView) {
                // Forward the call to our renderer to perform the drawing.
                renderer?.draw(in: view)
            }
        }

        // MARK: - NSViewRepresentable Methods

        // Called once to create the NSView (MTKView in our case).
        func makeNSView(context: Context) -> MTKView {
            // 1. Get the default Metal device.
            guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
                fatalError("Metal is not supported on this device.")
            }
            
            // 2. Assign the device to the MTKView.
            mtkView.device = defaultDevice
            
            // 3. Set the clear color (background).
            mtkView.clearColor = MTLClearColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.0)
            
            // 4. Assign the Coordinator as the MTKView's delegate.
            // The Coordinator holds the Renderer and handles the delegate calls.
            mtkView.delegate = context.coordinator
            
            return mtkView
        }

        // Called when SwiftUI needs to update the NSView.
        func updateNSView(_ nsView: MTKView, context: Context) {
            // No updates needed for our simple triangle
        }

        // Called to create the Coordinator for this representable view.
        func makeCoordinator() -> Coordinator {
            return Coordinator(mtkView: mtkView)
        }
}
