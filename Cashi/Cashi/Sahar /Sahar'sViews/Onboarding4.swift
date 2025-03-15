import SwiftUI
import CloudKit

struct Onboarding4View: View {
    @State private var isActive = false // State variable to control navigation
    
    var body: some View {
        ZStack {
            if isActive {
                LogInView() // Navigate to NextView when isActive is true
            } else {
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
                    
                    Spacer() // دفع المحتوى إلى المنتصف
                    HStack(alignment: .center, spacing: 40) {}
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
                    
                    Spacer() // دفع المحتوى إلى المنتصف
                    
                    // نص "ميزانية ذكية سهلة - نحن نقوم بالحسابات لك" (من Onboarding4View)
                    VStack {
                        Text("Smart budgeting made easy – we do the math for you")
                            .font(Font.custom("SF Pro Display", size: 22).weight(.bold))
                            .kerning(0.374)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 316, alignment: .top)
                        
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color.white.opacity(0.5)).frame(width: 6, height: 6)
                            Circle()
                                .fill(Color.white.opacity(0.5)).frame(width: 6, height: 6)
                            Circle()
                                .fill(Color.white).frame(width: 6, height: 6)
                        }
                        .padding(.top, 70)
                        .padding(.bottom, 20)
                        
                        // زر "التالي" (من Onboarding4View)
                        Button(action: {
                            isActive = true // Update isActive to trigger navigation
                        }) {
                            Text("Start Using Cashi")
                                .font(.system(size: 18, weight: .semibold)) // Adjust font as needed
                                .foregroundColor(.white)
                                .padding(.horizontal, 40) // Horizontal padding
                                .padding(.vertical, 15)  // Vertical padding
                                .background(
                                    RoundedRectangle(cornerRadius: 30) // Rounded corners
                                        .fill(Color.blue) // Blue fill color
                                )
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
                }
    }
    
    struct Onboarding4View_Previews: PreviewProvider {
            static var previews: some View {
                    Onboarding4View()
                }
    }
}
                                #Preview {
                                    Onboarding4View()
                                }
