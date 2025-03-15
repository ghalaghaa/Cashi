import SwiftUI
import CloudKit
import AuthenticationServices

struct LogInView: View {
    @StateObject private var viewModel = LogInViewModel()

    var body: some View {
        if viewModel.isActive {
            CloudKitUserView()
        } else {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.2, green: 0.2, blue: 0.5)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .padding(.top, 300)

                    Text("Log in to cashi")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, -10)

                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = UUID().uuidString
                            request.state = UUID().uuidString
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                if let credential = authResults.credential as? ASAuthorizationAppleIDCredential {
                                    viewModel.handleSignInWithApple(credential: credential)
                                } else {
                                    viewModel.errorMessage = "Failed to get Apple ID credential."
                                }
                            case .failure(let error):
                                viewModel.errorMessage = "Sign in with Apple failed: \(error.localizedDescription)"
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.white)
                    .frame(width: 325, height: 51)
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .inset(by: 0.35)
                            .stroke(Color(red: 0.1, green: 0.4, blue: 0.78), lineWidth: 0.7)
                    )
                    .padding(.top, 20)

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.top, 20)
                    }

                    Spacer()
                }
                .frame(width: 400, height: 845)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.1, green: 0.42, blue: 0.57), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.1, green: 0, blue: 0.35), location: 0.1),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.4, y: 1)
                    )
                )
                .cornerRadius(30)
            }
        }
    }
}

#Preview {
    LogInView()
}
