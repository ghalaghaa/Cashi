//
//  LogInView.swift
//  Cashi
//
//  Created by Ghala Alnemari on 16/03/1446 AH.
//

import SwiftUI
import AuthenticationServices

struct LogInView: View {
    @State private var isActive = false
    @State private var appleEmail: String = ""

    var body: some View {
        if isActive {
            // ✅ عند تسجيل الدخول بنجاح، انتقل إلى GoalsW مع تمرير البريد الإلكتروني
            GoalsW(appleEmail: appleEmail)
        } else {
            ZStack {
                // ✅ خلفية متدرجة
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.12, green: 0, blue: 0.47), location: 0.10),
                        Gradient.Stop(color: Color(red: 0.09, green: 0, blue: 0.35), location: 0.45),
                        Gradient.Stop(color: Color(red: 0.05, green: 0, blue: 0.22), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: -0.05, y: 0.07),
                    endPoint: UnitPoint(x: 0.17, y: 0.22)
                )
                .ignoresSafeArea()

                VStack {
                    // ✅ شعار التطبيق
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .padding(.top, 300)

                    // ✅ عنوان الشاشة
                    Text("Log in to Cashi")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    // ✅ زر تسجيل الدخول باستخدام Apple
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            request.requestedScopes = [.email]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                handleAppleSignIn(result: authResults)
                            case .failure(let error):
                                print("❌ Sign in failed: \(error.localizedDescription)")
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.whiteOutline)
                    .frame(height: 50)
                    .cornerRadius(50)
                    .padding(.horizontal)

                    Spacer()
                }
                .frame(width: 400, height: 844)
                .cornerRadius(30)
            }
        }
    }

    // ✅ دالة التعامل مع تسجيل الدخول عبر Apple
    func handleAppleSignIn(result: ASAuthorization) {
        guard let appleIDCredential = result.credential as? ASAuthorizationAppleIDCredential else { return }

        // ✅ الحصول على البريد الإلكتروني
        if let email = appleIDCredential.email {
            appleEmail = email
        } else {
            // لو كان المستخدم مسجل من قبل فلن تحصل على الإيميل مرة أخرى
            appleEmail = "Unknown"
        }

        // ✅ الانتقال إلى الشاشة التالية
        isActive = true
    }
}
