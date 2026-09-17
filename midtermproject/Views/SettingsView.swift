import SwiftUI
import Supabase

struct SettingsView: View {
    @EnvironmentObject var appController: AppController

    @State private var notificationsEnabled = true
    @State private var darkMode = false

    var body: some View {
        List {
            Section {
                Toggle(isOn: $notificationsEnabled) {
                    Label("Notifications", systemImage: "bell")
                }

                NavigationLink {
                    AccountInformationView()
                } label: {
                    Label("Account Information", systemImage: "person")
                }

                NavigationLink {
                    ChangePasswordView()
                } label: {
                    Label("Change Password", systemImage: "lock")
                }
            }

            Section {
                Toggle(isOn: $darkMode) {
                    Label("Dark Appearance", systemImage: "moon")
                }

                NavigationLink {
                    Text("English")
                        .navigationTitle("Language")
                } label: {
                    HStack {
                        Label("Language", systemImage: "globe")

                        Spacer()

                        Text("English")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                NavigationLink {
                    HelpSupportView()
                } label: {
                    Label("Help & Support", systemImage: "questionmark.circle")
                }
            }

            Section {
                Button(role: .destructive) {
                    Task {
                        await appController.logout()
                    }
                } label: {
                    HStack {
                        Spacer()

                        Text("Log Out")
                            .fontWeight(.semibold)

                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(darkMode ? .dark : .light)
    }
}

// MARK: - Account Information

struct AccountInformationView: View {
    @EnvironmentObject var appController: AppController

    var body: some View {
        Form {
            Section("Account") {
                LabeledContent(
                    "Name",
                    value: appController.userName
                )

                LabeledContent(
                    "Email",
                    value: appController.userEmail
                )

                LabeledContent(
                    "Course",
                    value: appController.course
                )
            }

            Section {
                Text("Your account information is connected to RoomPulse.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Account Information")
    }
}

// MARK: - Change Password

struct ChangePasswordView: View {
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var successMessage = ""

    var body: some View {
        Form {
            Section("Current Password") {
                SecureField(
                    "Current Password",
                    text: $oldPassword
                )
            }

            Section("New Password") {
                SecureField(
                    "New Password",
                    text: $newPassword
                )

                SecureField(
                    "Confirm New Password",
                    text: $confirmPassword
                )
            }

            if !errorMessage.isEmpty {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            if !successMessage.isEmpty {
                Section {
                    Text(successMessage)
                        .foregroundStyle(.green)
                }
            }

            Section {
                Button {
                    Task {
                        await updatePassword()
                    }
                } label: {
                    HStack {
                        Spacer()

                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Update Password")
                                .fontWeight(.semibold)
                        }

                        Spacer()
                    }
                }
                .disabled(
                    isLoading ||
                    oldPassword.isEmpty ||
                    newPassword.isEmpty ||
                    confirmPassword.isEmpty
                )
                .foregroundStyle(.green)
            }
        }
        .navigationTitle("Change Password")
    }

    @MainActor
    private func updatePassword() async {
        errorMessage = ""
        successMessage = ""

        guard newPassword.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        guard newPassword == confirmPassword else {
            errorMessage = "New passwords do not match."
            return
        }

        guard oldPassword != newPassword else {
            errorMessage = "Please choose a different password."
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            let session = try await supabase.auth.session

            guard let email = session.user.email else {
                errorMessage = "Unable to retrieve account email."
                return
            }

            _ = try await supabase.auth.signIn(
                email: email,
                password: oldPassword
            )

            try await supabase.auth.update(
                user: UserAttributes(
                    password: newPassword
                )
            )

            oldPassword = ""
            newPassword = ""
            confirmPassword = ""

            successMessage = "Password updated successfully!"

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Help and Support

struct HelpSupportView: View {
    var body: some View {
        List {
            Section("RoomPulse Support") {
                Text(
                    "For classroom concerns and application assistance, please contact your school administrator."
                )
            }

            Section("Common Questions") {
                Text("How do I submit a report?")
                Text("How can I check my report status?")
                Text("How do I update my account?")
            }

            Section("Application") {
                LabeledContent(
                    "App Name",
                    value: "RoomPulse"
                )

                LabeledContent(
                    "Version",
                    value: "1.0"
                )
            }
        }
        .navigationTitle("Help & Support")
    }
}
