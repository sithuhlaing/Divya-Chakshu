//
//  ContentView.swift
//  Divya-Chakshu
//
//  Created by Si Thu Hlaing on 25.07.25.
//

import SwiftUI
import MetalKit

struct ContentView: View {
    // State to hold our MetalView wrapper.
    // We create an instance of the MetalView and let SwiftUI manage its lifecycle.
    var body: some View {
        VStack {
            // Embed the MetalView into our SwiftUI hierarchy.
            // .frame(maxWidth: .infinity, maxHeight: .infinity) makes it fill available space.
            MetalView() // Create an instance of our representable view
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text("Hello Metal Triangle with SwiftUI!")
                .font(.title2)
                .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1)) // A light background for the VStack
    }
}
