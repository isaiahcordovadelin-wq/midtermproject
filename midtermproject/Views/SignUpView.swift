import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var appController: AppController
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var localError = ""

    var body: some View {
        Form {
            Section("Personal Information") {
                TextField("Full name", text: $name)
                    .textContentType(.name)

                TextField("Email address", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section("Create Password") {
                SecureField("Password", text: $password)
                    .textContentType(.newPassword)

                SecureField("Confirm password", text: $confirmPassword)
                    .textContentType(.newPassword)
            }

            if !localError.isEmpty {
                Text(localError)
                    .foregroundStyle(.red)
            }

            if !appController.errorMessage.isEmpty {
                Text(appController.errorMessage)
                    .foregroundStyle(.red)
            }

            Section {
                Button {
                    guard password == confirmPassword else {
                        localError = "Passwords do not match."
                        return
                    }

                    localError = ""

                    Task {
                        await appController.signUp(
                            name: name.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            email: email.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            password: password
                        )

                        if appController.isLoggedIn {
                            dismiss()
                        }
                    }
                } label: {
                    HStack {
                        Spacer()

                        if appController.isLoading {
                            ProgressView()
                        } else {
                            Text("Create Account")
                                .fontWeight(.semibold)
                        }

                        Spacer()
                    }
                }
                .disabled(
                    appController.isLoading ||
                    name.isEmpty ||
                    email.isEmpty ||
                    password.isEmpty ||
                    confirmPassword.isEmpty
                )
            }
        }
        .navigationTitle("Create Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}
