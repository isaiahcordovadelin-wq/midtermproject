
import Foundation
import Combine
import Supabase

@MainActor
class AppController: ObservableObject {

    @Published var isLoggedIn = false
    @Published var showSplash = true
    @Published var isLoading = false
    @Published var errorMessage = ""

    @Published var userName = "Student User"
    @Published var userEmail = ""
    @Published var course = "Information Technology"
    @Published var userRole = "student"

    func checkSession() async {
        do {
            _ = try await supabase.auth.session

            await fetchProfile()
            isLoggedIn = true

        } catch {
            isLoggedIn = false
            userRole = "student"
        }
    }

    func login(email: String, password: String) async {

        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }

        isLoading = true
        errorMessage = ""

        defer {
            isLoading = false
        }

        do {
            let session = try await supabase.auth.signIn(
                email: email,
                password: password
            )

            userEmail = session.user.email ?? email

            await fetchProfile()

            isLoggedIn = true

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signUp(
        name: String,
        email: String,
        password: String
    ) async {

        guard !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            errorMessage = "Please complete all fields."
            return
        }

        guard email.contains("@") else {
            errorMessage = "Please enter a valid email."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        isLoading = true
        errorMessage = ""

        defer {
            isLoading = false
        }

        do {
            let response = try await supabase.auth.signUp(
                email: email,
                password: password,
                data: [
                    "full_name": .string(name)
                ]
            )

            userName = name
            userEmail = email
            userRole = "student"

            if response.session != nil {
                await fetchProfile()
                isLoggedIn = true
            } else {
                errorMessage = "Account created. Please confirm your email before logging in."
            }

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func fetchProfile() async {

        guard let userID = try? await supabase.auth.session.user.id else {
            return
        }

        do {
            let profile: Profile = try await supabase
                .from("profiles")
                .select()
                .eq("id", value: userID)
                .single()
                .execute()
                .value

            userName = profile.fullName
            userEmail = profile.email
            userRole = (profile.role ?? "student").lowercased()

        } catch {
            userRole = "student"
            print("Profile loading error:", error.localizedDescription)
        }
    }

    func logout() async {

        do {
            try await supabase.auth.signOut()

            isLoggedIn = false
            userName = ""
            userEmail = ""
            userRole = "student"

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    struct Profile: Codable {
        let id: UUID
        let fullName: String
        let email: String
        let role: String?

        enum CodingKeys: String, CodingKey {
            case id
            case fullName = "full_name"
            case email
            case role
        }
    }
}
