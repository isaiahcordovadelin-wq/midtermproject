import Foundation
import Combine

class RoomController: ObservableObject {
    
    @Published var rooms: [Room] = SampleData.rooms
    
    var totalRooms: Int {
        rooms.count
    }
    
    var goodRooms: Int {
        rooms.filter {
            $0.status == "Good"
        }.count
    }
    
    var issueRooms: Int {
        rooms.filter {
            $0.status == "Issue"
        }.count
    }
}
