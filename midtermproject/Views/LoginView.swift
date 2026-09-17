import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appController: AppController

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 22) {
                Spacer()

                Image(systemName: "building.2.crop.circle.fill")
                    .font(.system(size: 76))
                    .foregroundStyle(RPTheme.green)

                VStack(spacing: 6) {
                    Text("Welcome to RoomPulse")
                        .font(.system(size: 27, weight: .bold))
                        .foregroundStyle(RPTheme.text)

                    Text("Sign in to monitor rooms and submit reports.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 14) {
                    TextField("Email address", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)

                    if !appController.errorMessage.isEmpty {
                        Text(appController.errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }

                    Button {
                        Task {
                            await appController.login(
                                email: email.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ),
                                password: password
                            )
                        }
                    } label: {
                        HStack {
                            Spacer()

                            if appController.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Login")
                                    .fontWeight(.semibold)
                            }

                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding(.vertical, 15)
                        .background(RPTheme.green)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                    }
                    .disabled(
                        appController.isLoading ||
                        email.isEmpty ||
                        password.isEmpty
                    )
                }

                HStack(spacing: 5) {
                    Text("Don't have an account?")
                        .foregroundStyle(.secondary)

                    NavigationLink("Sign Up") {
                        SignUpView()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(RPTheme.green)
                }
                .font(.subheadline)

                Spacer()
            }
            .padding(24)
            .background(
                RPTheme.background.ignoresSafeArea()
            )
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
