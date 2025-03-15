import SwiftUI
import CloudKit

struct Onboarding3View: View {
    @State private var isActive = false // State variable to control navigation

    var body: some View {
        ZStack {
            if isActive {
                Onboarding4View() // Navigate to NextView when isActive is true
            } else {
                // Your existing Onboarding3View content
                ZStack {
                    // الخلفية بتدرج لوني (من Onboarding4View)
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
                        // زر اللغة العربية (من Onboarding4View)
                        HStack {
                            Spacer()
                            Text("العربية")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold, design: .default))
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 110)

                        Spacer()

                        HStack(alignment: .center, spacing: 40) {} // Empty HStack?
                        .padding(.horizontal, 160)
                        .padding(.vertical, 20)
                        .background(Color(red: 0.09, green: 0, blue: 0.35))
                        .cornerRadius(15.525)
                        .padding(.top, -120)

                        // التبويبات (يومي، أسبوعي، شهري، سنوي) (من ContentView)
                        HStack {
                            Text("Daily")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            Text("Weekly")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            Text("Monthly")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            Text("Yearly")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }
                        .padding(.top, -120)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.17, green: 0.3, blue: 0.60))
                            .frame(width: 350, height: 100)
                            .overlay(
                                Text("$500")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue)
                                    .clipShape(Capsule())
                                    .offset(y: -50)
                            )
                            .padding(.top, -60)

                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.14, green: 0.06, blue: 0.39))
                                    .frame(width: 20, height: 20)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.14, green: 0.06, blue: 0.39))
                                    .frame(width: 20, height: 60)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.22, green: 0.43, blue: 1))
                                    .frame(width: 20, height: 50)
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(Color(red: 0.33, green: 0.5, blue: 0.98))
                                    .frame(width: 20, height: 40)
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(Color(red: 0.49, green: 0.62, blue: 1))
                                    .frame(width: 20, height: 60)
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(Color(red: 0.08, green: 0.32, blue: 1))
                                    .frame(width: 20, height: 45)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.12, green: 0.62, blue: 0.94))
                                    .frame(width: 13, height: 12)
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(Color(red: 0.62, green: 0.72, blue: 0.99))
                                    .frame(width: 20, height: 55)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.19, green: 0.38, blue: 0.93))
                                    .frame(width: 20, height: 49)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.14, green: 0.06, blue: 0.39))
                                    .frame(width: 20, height: 30)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.14, green: 0.06, blue: 0.39))
                                    .frame(width: 20, height: 60)
                            }
                            .padding(.top, -77)

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

struct Onboarding3View_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding3View()
    }
}
// ... (BottomCardView and NextView code remain the same)
