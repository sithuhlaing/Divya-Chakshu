import SwiftUI

struct ContentView: View {
    @State private var rotation = SIMD2<Float>(0, 0)
    @State private var lastRotation = SIMD2<Float>(0, 0)

    var body: some View {
        MetalView(rotation: $rotation)
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Map translation to rotation (dividing by 100 for sensitivity)
                        let xRotation = Float(value.translation.height) / 100.0
                        let yRotation = Float(value.translation.width) / 100.0
                        rotation = lastRotation + SIMD2<Float>(xRotation, yRotation)
                    }
                    .onEnded { _ in
                        lastRotation = rotation
                    }
            )
    }
}
