
import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var appController: AppController
    @ObservedObject var reportController: ReportController

    @State private var showLogoutConfirmation = false
    @State private var isLoggingOut = false

    var body: some View {

        NavigationStack {

            ScrollView(showsIndicators: false) {

                VStack(spacing: 22) {

                    // PROFILE HEADER
                    VStack(spacing: 12) {

                        ZStack {
                            Circle()
                                .fill(RPTheme.lightGreen)
                                .frame(width: 105, height: 105)

                            Text(
                                String(
                                    appController.userName
                                        .split(separator: " ")
                                        .prefix(2)
                                        .compactMap { $0.first }
                                )
                                .uppercased()
                            )
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(RPTheme.green)
                        }

                        Text(appController.userName)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(RPTheme.text)

                        Text(appController.userEmail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(appController.course)
                            .font(.caption.bold())
                            .foregroundStyle(RPTheme.green)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 8)
                            .background(RPTheme.lightGreen)
                            .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 25)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // MY ACTIVITY
                    VStack(alignment: .leading, spacing: 13) {

                        Text("My Activity")
                            .font(.headline)
                            .foregroundStyle(RPTheme.text)

                        HStack(spacing: 10) {

                            ReportStatCard(
                                title: "Submitted",
                                value: reportController.totalReports,
                                color: RPTheme.green
                            )

                            ReportStatCard(
                                title: "Active",
                                value: reportController.activeReports,
                                color: .orange
                            )

                            ReportStatCard(
                                title: "Resolved",
                                value: reportController.resolvedReports,
                                color: .green
                            )
                        }
                    }

                    // ACCOUNT
                    VStack(alignment: .leading, spacing: 12) {

                        Text("Account")
                            .font(.headline)
                            .foregroundStyle(RPTheme.text)

                        VStack(spacing: 0) {

                            NavigationLink {
                                AccountInformationView()
                            } label: {
                                ProfileMenuRow(
                                    icon: "person.text.rectangle",
                                    title: "Account Information"
                                )
                            }

                            Divider().padding(.leading, 52)

                            NavigationLink {
                                MyReportsView(
                                    reportController: reportController
                                )
                            } label: {
                                ProfileMenuRow(
                                    icon: "doc.text",
                                    title: "My Reports"
                                )
                            }

                            Divider().padding(.leading, 52)

                            NavigationLink {
                                NotificationsView()
                            } label: {
                                ProfileMenuRow(
                                    icon: "bell",
                                    title: "Notifications"
                                )
                            }

                            Divider().padding(.leading, 52)

                            NavigationLink {
                                SettingsView()
                            } label: {
                                ProfileMenuRow(
                                    icon: "gearshape",
                                    title: "Settings"
                                )
                            }
                        }
                        .padding(.horizontal, 15)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }

                    // LOG OUT BUTTON
                    Button {
                        showLogoutConfirmation = true
                    } label: {

                        HStack(spacing: 12) {

                            if isLoggingOut {
                                ProgressView()
                                    .tint(.red)
                            } else {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }

                            Text(isLoggingOut ? "Logging Out..." : "Log Out")
                                .font(.system(size: 15, weight: .semibold))

                            Spacer()
                        }
                        .foregroundStyle(.red)
                        .padding(18)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .disabled(isLoggingOut)
                    .confirmationDialog(
                        "Are you sure you want to log out?",
                        isPresented: $showLogoutConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Log Out", role: .destructive) {
                            Task {
                                isLoggingOut = true
                                await appController.logout()
                                isLoggingOut = false
                            }
                        }

                        Button("Cancel", role: .cancel) { }
                    }

                    Text("ROOMPULSE • CAMPUS ROOM MONITOR")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(1)
                        .foregroundStyle(.secondary)
                        .padding(.top, 5)
                }
                .padding(20)
            }
            .background(RPTheme.background.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct ProfileMenuRow: View {

    let icon: String
    let title: String

    var body: some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.system(size: 17))
                .foregroundStyle(RPTheme.green)
                .frame(width: 25)

            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(RPTheme.text)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 17)
        .contentShape(Rectangle())
    }
}
