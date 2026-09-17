import Foundation

struct RoomReport: Identifiable {
    let id = UUID()
    
    let room: String
    let category: String
    let description: String
    let status: String
}
