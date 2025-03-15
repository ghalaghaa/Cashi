import SwiftUI
import Charts
import CloudKit

struct Onboarding2: View {
    @State private var isActive = false // State variable to control navigation

    var body: some View {
        ZStack {
            if isActive {
                Onboarding3View() // Navigate to NextView when isActive is true
            } else {
                ZStack {
                    // الخلفية بتدرج لوني
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
                        HStack {
                            Spacer()
                            Text("العربية")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold, design: .default))
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 110)

                        Spacer()

                        VStack {
                            Image("vector2") // Make sure you have "vector2" image in Assets Catalog
                                .resizable()
                                .scaledToFit()
                                .frame(width: 590, height: 200)
                                .offset(y: -20)
                                .padding(-100)
                                .shadow(radius: 90)
                        }
                        .padding(.top, -30)

                        Spacer()

                        BottomCardView(action: { // Pass the action to BottomCardView
                            isActive = true // Update isActive to trigger navigation
                        })
                    }
                }
            }
        }
    }
}

struct BtomCardView: View {
    var action: () -> Void // Action to perform when the button is tapped

    var body: some View {
        VStack {
            Text("Smart saving starts here – plan, save, and achieve")
                .font(
                    Font.custom("SF Pro Display", size: 22)
                        .weight(.bold)
                )
                .kerning(0.374)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 340, alignment: .top)

            HStack(spacing: 10) {
                Circle()
                    .fill(Color.white.opacity(0.5)).frame(width: 6, height: 6)
                Circle().fill(Color.white).frame(width: 6, height: 6)
                Circle().fill(Color.white.opacity(0.5)).frame(width: 6, height: 6)
            }
            .padding(.top, 70)
            .padding(.bottom, 20)

            Button(action: {
                action() // Call the passed action
            }) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
                    .padding(25)
                    .background(Color.blue.opacity(0.8))
                    .clipShape(Circle())
            }
            .padding(.bottom, 130)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 350)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.17, green: 0.3, blue: 0.60), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.02, green: 0, blue: 0.2), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        .cornerRadius(40)
        .padding(.horizontal, 10)
    }
}



struct Onboarding2_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding2()
    }
}
