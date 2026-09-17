
import SwiftUI

struct MyReportsView: View {

    @ObservedObject var reportController: ReportController

    @State private var selectedFilter = "All"

    private let filters = ["All", "Active", "Resolved"]

    private var filteredReports: [RoomReport] {
        switch selectedFilter {
        case "Active":
            return reportController.reports.filter {
                $0.status != "Fixed"
            }
        case "Resolved":
            return reportController.reports.filter {
                $0.status == "Fixed"
            }
        default:
            return reportController.reports
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 22) {

                VStack(alignment: .leading, spacing: 6) {
                    Text("My Reports")
                        .font(.system(size: 27, weight: .bold))
                        .foregroundStyle(RPTheme.text)

                    Text("Monitor the progress of your submitted concerns.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 10) {
                    ReportStatCard(
                        title: "Total",
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

                HStack(spacing: 8) {
                    ForEach(filters, id: \.self) { filter in
                        Button {
                            withAnimation {
                                selectedFilter = filter
                            }
                        } label: {
                            Text(filter)
                                .font(.caption.bold())
                                .foregroundStyle(
                                    selectedFilter == filter
                                    ? .white
                                    : RPTheme.text
                                )
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    selectedFilter == filter
                                    ? RPTheme.green
                                    : .white
                                )
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }

                HStack {
                    Text("Submission History")
                        .font(.headline)
                        .foregroundStyle(RPTheme.text)

                    Spacer()

                    Text("\(filteredReports.count) reports")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if filteredReports.isEmpty {
                    ContentUnavailableView(
                        "No Reports Found",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("There are no reports in this category.")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredReports) { report in
                            NavigationLink {
                                ReportDetailsView(report: report)
                            } label: {
                                ReportHistoryCard(report: report)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(RPTheme.background.ignoresSafeArea())
        .navigationTitle("My Reports")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReportStatCard: View {

    let title: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(value)")
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(color)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct ReportHistoryCard: View {

    let report: RoomReport

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: "doc.text.fill")
                .font(.title3)
                .foregroundStyle(RPTheme.green)
                .frame(width: 45, height: 45)
                .background(RPTheme.lightGreen)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 5) {
                Text(report.room)
                    .font(.subheadline.bold())
                    .foregroundStyle(RPTheme.text)

                Text(report.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(report.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 4)

            VStack(alignment: .trailing, spacing: 8) {
                StatusBadge(status: report.status)

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 17))
    }
}
