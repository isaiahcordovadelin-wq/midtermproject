import SwiftUI

struct ReportDetailsView: View {
    let report: RoomReport

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Report Details")
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    StatusBadge(status: report.status)
                }

                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(
                        title: "Room",
                        value: report.room
                    )

                    Divider()

                    DetailRow(
                        title: "Category",
                        value: report.category
                    )

                    Divider()

                    DetailRow(
                        title: "Description",
                        value: report.description
                    )

                    Divider()

                    DetailRow(
                        title: "Status",
                        value: report.status
                    )

                    Divider()

                    DetailRow(
                        title: "Submitted",
                        value: report.date.formatted(
                            date: .abbreviated,
                            time: .shortened
                        )
                    )
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))

                Text("Report Timeline")
                    .font(.headline)

                TimelineItem(
                    title: "Reported",
                    subtitle: "Report submitted",
                    color: .green,
                    isActive: true
                )

                TimelineItem(
                    title: "In Progress",
                    subtitle: report.status == "Reported"
                        ? "Pending"
                        : "Being reviewed",
                    color: .orange,
                    isActive: report.status != "Reported"
                )

                TimelineItem(
                    title: "Fixed",
                    subtitle: report.status == "Fixed"
                        ? "Issue resolved"
                        : "Pending",
                    color: .blue,
                    isActive: report.status == "Fixed"
                )
            }
            .padding()
        }
        .navigationTitle("Report Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TimelineItem: View {
    let title: String
    let subtitle: String
    let color: Color
    let isActive: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .fill(
                        isActive
                        ? color
                        : Color.gray.opacity(0.3)
                    )
                    .frame(width: 16, height: 16)

                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 2, height: 35)
            }

            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text(title)
                    .fontWeight(.semibold)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
