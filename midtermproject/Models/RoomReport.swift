import Foundation

struct RoomReport: Identifiable, Codable, Hashable {
    let id: UUID
    let userId: UUID
    let roomId: UUID?
    let room: String
    let category: String
    let description: String
    let status: String
    let photoURL: String?
    let date: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case roomId = "room_id"
        case room = "room_label"
        case category
        case description
        case status
        case photoURL = "photo_url"
        case date = "created_at"
    }
}
