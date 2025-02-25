//
//  ContentView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 24/08/1446 AH.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}


import SwiftUI

//struct ContentView: View {
//
//        @State private var imageIndex = 0
//        @State private var animationRunning = true
//
//        private let images = (1...10).map { "\($0)" }
//
//        var body: some View {
//            Image(images[imageIndex])
//                .resizable()
//                .scaledToFill()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .ignoresSafeArea()
//                .onAppear {
//                    startAnimation()
//                }
//        }
//
//        private func startAnimation() {
//            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//                imageIndex = (imageIndex + 1) % images.count
//
////                if imageIndex == images.count - 1 {
////                    timer.invalidate()
////                    animationRunning = false
////                }
//            }
//        }
//    }


#Preview {
    ContentView()
}


struct ContentView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
            Color(hex: "1F0179").opacity(1.0), // 100%
            Color(hex: "160158").opacity(1.0), // 100%
            Color(hex: "0E0137").opacity(1.0)  // 100%
        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true))
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

//
//#Preview {
//    AnimatedBackgroundView()
//}
