
import Foundation
import Combine
import Supabase

struct RoomAvailabilityUpdate: Encodable {
    let status: String
    let issueDescription: String

    enum CodingKeys: String, CodingKey {
        case status
        case issueDescription = "issue"
    }
}

@MainActor
class RoomController: ObservableObject {

    @Published var rooms: [Room] = []
    @Published var isLoading = false
    @Published var isUpdating = false
    @Published var errorMessage = ""

    var totalRooms: Int {
        rooms.count
    }

    var goodRooms: Int {
        rooms.filter { $0.status == "Good" }.count
    }

    var issueRooms: Int {
        rooms.filter { $0.status == "Issue" }.count
    }

    var unavailableRooms: Int {
        rooms.filter { $0.status == "Unavailable" }.count
    }

    // FETCH ROOMS FROM SUPABASE
    func fetchRooms() async {

        isLoading = true
        errorMessage = ""

        defer {
            isLoading = false
        }

        do {
            let result: [Room] = try await supabase
                .from("rooms")
                .select()
                .order("number")
                .execute()
                .value

            rooms = result

        } catch {
            errorMessage = error.localizedDescription
            print("Room fetch error:", error)
        }
    }

    // UPDATE ROOM AVAILABILITY
    func updateRoomAvailability(
        roomID: UUID,
        status: String,
        issueDescription: String
    ) async -> Bool {

        isUpdating = true
        errorMessage = ""

        defer {
            isUpdating = false
        }

        do {

            let updateData = RoomAvailabilityUpdate(
                status: status,
                issueDescription: issueDescription
            )

            try await supabase
                .from("rooms")
                .update(updateData)
                .eq("id", value: roomID.uuidString)
                .execute()

            await fetchRooms()

            return true

        } catch {

            errorMessage = error.localizedDescription
            print("Room availability update error:", error)

            return false
        }
    }

    // REFRESH ROOMS
    func refreshRooms() async {
        await fetchRooms()
    }
}
