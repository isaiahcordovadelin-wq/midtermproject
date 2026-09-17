
import Foundation
import Combine
import Supabase

@MainActor
class ReportController: ObservableObject {

    @Published var reports: [RoomReport] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    var totalReports: Int {
        reports.count
    }

    var activeReports: Int {
        reports.filter {
            $0.status != "Fixed" && $0.status != "Rejected"
        }.count
    }

    var resolvedReports: Int {
        reports.filter {
            $0.status == "Fixed"
        }.count
    }

    var pendingReports: Int {
        reports.filter {
            $0.status == "Reported" || $0.status == "Pending"
        }.count
    }

    var inProgressReports: Int {
        reports.filter {
            $0.status == "In Progress"
        }.count
    }

    // Student: fetch only their own reports.
    func fetchReports() async {

        isLoading = true
        errorMessage = ""

        defer {
            isLoading = false
        }

        do {
            let userID = try await supabase.auth.session.user.id

            let result: [RoomReport] = try await supabase
                .from("reports")
                .select()
                .eq("user_id", value: userID)
                .order("created_at", ascending: false)
                .execute()
                .value

            reports = result

        } catch {
            errorMessage = error.localizedDescription
            print("Report fetch error:", error)
        }
    }

    // Admin: fetch reports from all users.
    func fetchAllReports() async {

        isLoading = true
        errorMessage = ""

        defer {
            isLoading = false
        }

        do {
            let result: [RoomReport] = try await supabase
                .from("reports")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value

            reports = result

        } catch {
            errorMessage = error.localizedDescription
            print("Admin report fetch error:", error)
        }
    }

    // Admin: update a report's status.
    func updateReportStatus(
        reportID: UUID,
        status: String
    ) async -> Bool {

        isLoading = true
        errorMessage = ""

        defer {
            isLoading = false
        }

        do {
            let update = ReportStatusUpdate(status: status)

            try await supabase
                .from("reports")
                .update(update)
                .eq("id", value: reportID.uuidString)
                .execute()

            await fetchAllReports()
            return true

        } catch {
            errorMessage = error.localizedDescription
            print("Report status update error:", error)
            return false
        }
    }

    // Student: submit a report.
    func addReport(
        room: String,
        category: String,
        description: String
    ) async {

        isLoading = true
        errorMessage = ""

        defer {
            isLoading = false
        }

        guard !room.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter the room and describe the issue."
            return
        }

        do {
            let userID = try await supabase.auth.session.user.id

            let newReport = NewRoomReport(
                userId: userID,
                room: room,
                category: category,
                description: description,
                status: "Reported"
            )

            try await supabase
                .from("reports")
                .insert(newReport)
                .execute()

            await fetchReports()

        } catch {
            errorMessage = error.localizedDescription
            print("Report submission error:", error)
        }
    }
}

private struct ReportStatusUpdate: Encodable {
    let status: String
}

private struct NewRoomReport: Encodable {

    let userId: UUID
    let room: String
    let category: String
    let description: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case room = "room_label"
        case category
        case description
        case status
    }
}
