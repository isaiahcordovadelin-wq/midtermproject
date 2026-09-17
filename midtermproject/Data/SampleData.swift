import Foundation

struct SampleData {
    
    static let rooms: [Room] = [
        Room(
            number: "201",
            building: "Main Building",
            capacity: 40,
            status: "Good",
            issue: "No reported issues"
        ),
        
        Room(
            number: "202",
            building: "Main Building",
            capacity: 40,
            status: "Issue",
            issue: "Projector not working"
        ),
        
        Room(
            number: "203",
            building: "Main Building",
            capacity: 35,
            status: "Good",
            issue: "No reported issues"
        ),
        
        Room(
            number: "204",
            building: "Main Building",
            capacity: 45,
            status: "Issue",
            issue: "Air conditioning problem"
        ),
        
        Room(
            number: "301",
            building: "Science Building",
            capacity: 40,
            status: "Good",
            issue: "No reported issues"
        ),
        
        Room(
            number: "302",
            building: "Science Building",
            capacity: 30,
            status: "Good",
            issue: "No reported issues"
        )
    ]
    
    static let reports: [RoomReport] = [
        RoomReport(
            room: "202",
            category: "Projector",
            description: "Projector is not working.",
            status: "In Progress"
        ),
        
        RoomReport(
            room: "204",
            category: "Air Conditioning",
            description: "Air conditioner needs checking.",
            status: "Reported"
        ),
        
        RoomReport(
            room: "203",
            category: "Furniture",
            description: "Some chairs need checking.",
            status: "Fixed"
        )
    ]
}
