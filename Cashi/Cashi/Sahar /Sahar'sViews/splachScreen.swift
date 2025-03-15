import SwiftUI

struct SplashScreen: View {
    // Your main content view
    var body: some View {
        Text("Hello, World!") // Replace with your actual content
    }
}

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            if self.isActive {
                OnboardingView() // Navigate to ContentView after splash screen
            } else {
                ZStack {
                    ZStack {}
                    .frame(width: 450, height: 990)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.12, green: 0, blue: 0.47), location: 0.10),
                                Gradient.Stop(color: Color(red: 0.09, green: 0, blue: 0.35), location: 0.45),
                                Gradient.Stop(color: Color(red: 0.05, green: 0, blue: 0.22), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: -0.05, y: 0.07),
                            endPoint: UnitPoint(x: 0.17, y: 0.22)
                        )
                    )
                    .cornerRadius(30)

                    VStack {
                        Image("logo") // Make sure you have the "logo" image in your Assets Catalog
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.top,-40)

                        Text("Small Steps to Big Dreams")
                            .font(
                                Font.custom("SF Pro", size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.white)
                            .padding(.top,-25)
                    }
                }
                .onAppear {
                    // Simulate a delay for the splash screen (e.g., 2 seconds)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
