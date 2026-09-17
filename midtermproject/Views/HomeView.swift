import SwiftUI

struct HomeView: View {
    @ObservedObject var roomController: RoomController
    @ObservedObject var reportController: ReportController

    @EnvironmentObject var appController: AppController

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("ROOMPULSE")
                                .font(.system(size: 13, weight: .bold))
                                .tracking(2)
                                .foregroundStyle(RPTheme.green)

                            Text(
                                "Hello, \(appController.userName.components(separatedBy: " ").first ?? "Student")!"
                            )
                            .font(.system(size: 27, weight: .bold))
                            .foregroundStyle(RPTheme.text)

                            Text("Here's your campus overview.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        NavigationLink {
                            NotificationsView()
                        } label: {
                            Image(systemName: "bell.badge")
                                .font(.system(size: 19, weight: .semibold))
                                .foregroundStyle(RPTheme.green)
                                .frame(width: 48, height: 48)
                                .background(.white)
                                .clipShape(Circle())
                        }
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("CAMPUS STATUS")
                                    .font(.caption2.bold())
                                    .tracking(1.5)
                                    .foregroundStyle(.white.opacity(0.75))

                                Text("A better space\nstarts with you.")
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundStyle(.white)

                                Text("Monitor rooms and report facility concerns.")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.85))
                            }

                            Spacer()

                            Image(systemName: "building.2.crop.circle.fill")
                                .font(.system(size: 65))
                                .foregroundStyle(.white.opacity(0.9))
                        }

                        HStack(spacing: 7) {
                            Circle()
                                .fill(.green.opacity(0.9))
                                .frame(width: 8, height: 8)

                            Text(
                                "Monitoring \(roomController.totalRooms) campus rooms"
                            )
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .background(.white.opacity(0.15))
                        .clipShape(Capsule())
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background {
                        LinearGradient(
                            colors: [
                                RPTheme.green,
                                Color(red: 0.10, green: 0.34, blue: 0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 22))

                    VStack(alignment: .leading, spacing: 13) {
                        Text("Room Overview")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundStyle(RPTheme.text)

                        HStack(spacing: 10) {
                            DashboardStat(
                                title: "Total Rooms",
                                value: "\(roomController.totalRooms)",
                                icon: "building.2.fill",
                                color: RPTheme.green
                            )

                            DashboardStat(
                                title: "Good Condition",
                                value: "\(roomController.goodRooms)",
                                icon: "checkmark.circle.fill",
                                color: .green
                            )

                            DashboardStat(
                                title: "With Issues",
                                value: "\(roomController.issueRooms)",
                                icon: "exclamationmark.triangle.fill",
                                color: .orange
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 13) {
                        Text("Quick Actions")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundStyle(RPTheme.text)

                        HStack(spacing: 12) {
                            NavigationLink {
                                RoomsView(
                                    roomController: roomController,
                                    reportController: reportController
                                )
                            } label: {
                                QuickActionCard(
                                    title: "Browse Rooms",
                                    subtitle: "Check room status",
                                    icon: "building.2.fill"
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink {
                                MyReportsView(
                                    reportController: reportController
                                )
                            } label: {
                                QuickActionCard(
                                    title: "My Reports",
                                    subtitle: "Track submissions",
                                    icon: "doc.text.fill"
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    VStack(alignment: .leading, spacing: 13) {
                        HStack {
                            Text("Recent Reports")
                                .font(.system(size: 19, weight: .bold))
                                .foregroundStyle(RPTheme.text)

                            Spacer()

                            NavigationLink {
                                MyReportsView(
                                    reportController: reportController
                                )
                            } label: {
                                Text("See All")
                                    .font(.caption.bold())
                                    .foregroundStyle(RPTheme.green)
                            }
                        }

                        if reportController.reports.isEmpty {
                            ContentUnavailableView(
                                "No Reports Yet",
                                systemImage: "doc.text",
                                description: Text(
                                    "Your submitted reports will appear here."
                                )
                            )
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        } else {
                            ForEach(reportController.reports.prefix(3)) { report in
                                NavigationLink {
                                    ReportDetailsView(report: report)
                                } label: {
                                    ReportRow(report: report)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    HStack(spacing: 10) {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(RPTheme.green)

                        Text(
                            "Help keep campus facilities safe, clean, and functional."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RPTheme.lightGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(20)
            }
            .background(RPTheme.background.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct DashboardStat: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            Text(value)
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(RPTheme.text)

            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(RPTheme.green)
                .frame(width: 43, height: 43)
                .background(RPTheme.lightGreen)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(RPTheme.text)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct ReportRow: View {
    let report: RoomReport

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text.fill")
                .font(.title3)
                .foregroundStyle(RPTheme.green)
                .frame(width: 43, height: 43)
                .background(RPTheme.lightGreen)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 5) {
                Text(report.room)
                    .font(.subheadline.bold())
                    .foregroundStyle(RPTheme.text)

                Text(report.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(
                    report.date.formatted(
                        date: .abbreviated,
                        time: .shortened
                    )
                )
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 4)

            StatusBadge(status: report.status)
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
