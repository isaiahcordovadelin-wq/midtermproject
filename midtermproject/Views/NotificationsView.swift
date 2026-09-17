import SwiftUI

struct NotificationsView: View {
    private let notifications = SampleData.notifications

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Notifications")
                        .font(.system(size: 27, weight: .bold))
                        .foregroundStyle(RPTheme.text)

                    Text("Stay updated with campus room activities.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if notifications.isEmpty {
                    ContentUnavailableView(
                        "No Notifications",
                        systemImage: "bell.slash",
                        description: Text("You're all caught up.")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                } else {
                    ForEach(notifications) { notification in
                        NotificationCard(notification: notification)
                    }
                }
            }
            .padding(20)
        }
        .background(RPTheme.background.ignoresSafeArea())
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationCard: View {
    let notification: AppNotification

    private var icon: String {
        switch notification.type {
        case "success":
            return "checkmark.circle.fill"
        case "warning":
            return "exclamationmark.triangle.fill"
        default:
            return "bell.badge.fill"
        }
    }

    private var color: Color {
        switch notification.type {
        case "success":
            return .green
        case "warning":
            return .orange
        default:
            return .blue
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 43, height: 43)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 13))

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(notification.title)
                        .font(.subheadline.bold())
                        .foregroundStyle(RPTheme.text)

                    Spacer()

                    if !notification.isRead {
                        Circle()
                            .fill(RPTheme.green)
                            .frame(width: 8, height: 8)
                    }
                }

                Text(notification.message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(notification.time)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(15)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 17))
    }
}
