
import SwiftUI

// MARK: - ADMIN TAB NAVIGATION

struct AdminTabView: View {

    @ObservedObject var roomController: RoomController
    @ObservedObject var reportController: ReportController

    var body: some View {

        TabView {

            AdminDashboardView(
                roomController: roomController,
                reportController: reportController
            )
            .tabItem {
                Label("Dashboard", systemImage: "square.grid.2x2.fill")
            }

            AdminReportsView(
                reportController: reportController
            )
            .tabItem {
                Label("Reports", systemImage: "doc.text.fill")
            }

            RoomsView(
                roomController: roomController,
                reportController: reportController
            )
            .tabItem {
                Label("Rooms", systemImage: "building.2.fill")
            }

            ProfileView(
                reportController: reportController
            )
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
        }
        .tint(RPTheme.green)
    }
}

// MARK: - ADMIN DASHBOARD

struct AdminDashboardView: View {

    @EnvironmentObject var appController: AppController

    @ObservedObject var roomController: RoomController
    @ObservedObject var reportController: ReportController

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {

        NavigationStack {

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 22) {

                    VStack(alignment: .leading, spacing: 6) {

                        Text("ROOMPULSE ADMIN")
                            .font(.caption.bold())
                            .tracking(1.5)
                            .foregroundStyle(RPTheme.green)

                        Text("Dashboard")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(RPTheme.text)

                        Text("Welcome, \(appController.userName)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // REPORT STATISTICS

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Report Overview")
                            .font(.headline)
                            .foregroundStyle(RPTheme.text)

                        LazyVGrid(columns: columns, spacing: 12) {

                            AdminMetricCard(
                                title: "Total Reports",
                                value: reportController.totalReports,
                                icon: "doc.text.fill",
                                color: RPTheme.green
                            )

                            AdminMetricCard(
                                title: "Pending",
                                value: reportController.pendingReports,
                                icon: "clock.fill",
                                color: .orange
                            )

                            AdminMetricCard(
                                title: "In Progress",
                                value: reportController.inProgressReports,
                                icon: "wrench.and.screwdriver.fill",
                                color: .blue
                            )

                            AdminMetricCard(
                                title: "Resolved",
                                value: reportController.resolvedReports,
                                icon: "checkmark.circle.fill",
                                color: .green
                            )
                        }
                    }

                    // ROOM STATISTICS

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Room Overview")
                            .font(.headline)
                            .foregroundStyle(RPTheme.text)

                        HStack(spacing: 12) {

                            AdminMetricCard(
                                title: "Total Rooms",
                                value: roomController.totalRooms,
                                icon: "building.2.fill",
                                color: RPTheme.green
                            )

                            AdminMetricCard(
                                title: "Rooms with Issues",
                                value: roomController.issueRooms,
                                icon: "exclamationmark.triangle.fill",
                                color: .orange
                            )
                        }
                    }

                    // RECENT REPORTS

                    VStack(alignment: .leading, spacing: 12) {

                        HStack {

                            Text("Recent Reports")
                                .font(.headline)
                                .foregroundStyle(RPTheme.text)

                            Spacer()

                            NavigationLink {
                                AdminReportsView(
                                    reportController: reportController
                                )
                            } label: {
                                Text("View All")
                                    .font(.caption.bold())
                                    .foregroundStyle(RPTheme.green)
                            }
                        }

                        if reportController.reports.isEmpty {

                            Text("No reports submitted yet.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(25)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))

                        } else {

                            ForEach(
                                Array(reportController.reports.prefix(5))
                            ) { report in

                                NavigationLink {
                                    AdminReportDetailView(
                                        report: report,
                                        reportController: reportController
                                    )
                                } label: {
                                    AdminReportRow(report: report)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(RPTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .refreshable {
                await reportController.fetchAllReports()
                await roomController.fetchRooms()
            }
        }
        .task {
            await reportController.fetchAllReports()
            await roomController.fetchRooms()
        }
    }
}

// MARK: - METRIC CARD

struct AdminMetricCard: View {

    let title: String
    let value: Int
    let icon: String
    let color: Color

    var body: some View {

        VStack(alignment: .leading, spacing: 13) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            Text("\(value)")
                .font(.system(size: 27, weight: .bold))
                .foregroundStyle(RPTheme.text)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 17))
    }
}

// MARK: - ADMIN REPORT LIST

struct AdminReportsView: View {

    @ObservedObject var reportController: ReportController

    var body: some View {

        NavigationStack {

            Group {

                if reportController.isLoading &&
                    reportController.reports.isEmpty {

                    ProgressView("Loading reports...")

                } else if reportController.reports.isEmpty {

                    ContentUnavailableView(
                        "No Reports",
                        systemImage: "doc.text",
                        description: Text("Submitted reports will appear here.")
                    )

                } else {

                    List {

                        ForEach(reportController.reports) { report in

                            NavigationLink {

                                AdminReportDetailView(
                                    report: report,
                                    reportController: reportController
                                )

                            } label: {

                                AdminReportRow(report: report)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Manage Reports")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await reportController.fetchAllReports()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .refreshable {
                await reportController.fetchAllReports()
            }
        }
        .task {
            await reportController.fetchAllReports()
        }
    }
}

// MARK: - REPORT ROW

struct AdminReportRow: View {

    let report: RoomReport

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            HStack {

                Text(report.room)
                    .font(.headline)
                    .foregroundStyle(RPTheme.text)

                Spacer()

                Text(report.status)
                    .font(.caption.bold())
                    .foregroundStyle(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            Text(report.category)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(report.description)
                .font(.caption)
                .foregroundStyle(RPTheme.text)
                .lineLimit(2)

            Text(report.date.formatted(
                date: .abbreviated,
                time: .shortened
            ))
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 7)
    }

    private var statusColor: Color {

        switch report.status {
        case "Fixed":
            return .green
        case "In Progress":
            return .blue
        case "Rejected":
            return .red
        default:
            return .orange
        }
    }
}

// MARK: - ADMIN REPORT DETAILS

struct AdminReportDetailView: View {

    let report: RoomReport

    @ObservedObject var reportController: ReportController

    @State private var selectedStatus = "Reported"
    @State private var showSuccess = false
    @State private var showError = false

    private let statusOptions = [
        "Reported",
        "In Progress",
        "Fixed",
        "Rejected"
    ]

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 9) {

                    Text(report.room)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(RPTheme.text)

                    Text(report.category)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(report.date.formatted(
                        date: .complete,
                        time: .shortened
                    ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Description")
                        .font(.headline)

                    Text(report.description)
                        .font(.body)
                        .foregroundStyle(RPTheme.text)
                }
                .padding(17)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                if let photo = report.photoURL,
                   let url = URL(string: photo) {

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Attached Photo")
                            .font(.headline)

                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }

                VStack(alignment: .leading, spacing: 12) {

                    Text("Update Report Status")
                        .font(.headline)

                    Picker(
                        "Status",
                        selection: $selectedStatus
                    ) {
                        ForEach(statusOptions, id: \.self) { status in
                            Text(status).tag(status)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(RPTheme.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button {

                        Task {
                            let success = await reportController.updateReportStatus(
                                reportID: report.id,
                                status: selectedStatus
                            )

                            if success {
                                showSuccess = true
                            } else {
                                showError = true
                            }
                        }

                    } label: {

                        HStack {

                            if reportController.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                            }

                            Text("Save Status")
                                .fontWeight(.bold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(15)
                        .background(RPTheme.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(reportController.isLoading)
                }
                .padding(17)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(20)
        }
        .background(RPTheme.background.ignoresSafeArea())
        .navigationTitle("Report Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedStatus = report.status
        }
        .alert("Status Updated", isPresented: $showSuccess) {
            Button("Done", role: .cancel) { }
        } message: {
            Text("The report status has been updated.")
        }
        .alert("Update Failed", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(reportController.errorMessage)
        }
    }
}
//
//  AdminDashboardView.swift
//  midtermproject
//
//  Created by Mac-LAB on 11/18/26.
//

