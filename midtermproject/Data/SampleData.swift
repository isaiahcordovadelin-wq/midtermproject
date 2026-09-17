import Foundation

struct SampleData {
    static let rooms: [Room] = [
        Room(
            id: UUID(),
            number: "201",
            building: "Main Building",
            capacity: 40,
            status: "Good",
            issue: "No reported issues"
        ),
        Room(
            id: UUID(),
            number: "202",
            building: "Main Building",
            capacity: 40,
            status: "Issue",
            issue: "Projector not working"
        ),
        Room(
            id: UUID(),
            number: "203",
            building: "Main Building",
            capacity: 35,
            status: "Good",
            issue: "No reported issues"
        ),
        Room(
            id: UUID(),
            number: "204",
            building: "Main Building",
            capacity: 45,
            status: "Issue",
            issue: "Air conditioning problem"
        ),
        Room(
            id: UUID(),
            number: "301",
            building: "Science Building",
            capacity: 40,
            status: "Good",
            issue: "No reported issues"
        ),
        Room(
            id: UUID(),
            number: "302",
            building: "Science Building",
            capacity: 30,
            status: "Good",
            issue: "No reported issues"
        )
    ]

    static let reports: [RoomReport] = [
        RoomReport(
            id: UUID(),
            userId: UUID(),
            roomId: nil,
            room: "Room 202",
            category: "Projector",
            description: "Projector is not working.",
            status: "In Progress",
            photoURL: nil,
            date: Date()
        ),
        RoomReport(
            id: UUID(),
            userId: UUID(),
            roomId: nil,
            room: "Room 204",
            category: "Air Conditioning",
            description: "Air conditioner needs checking.",
            status: "Reported",
            photoURL: nil,
            date: Date().addingTimeInterval(-3600)
        ),
        RoomReport(
            id: UUID(),
            userId: UUID(),
            roomId: nil,
            room: "Room 203",
            category: "Furniture",
            description: "Some chairs need checking.",
            status: "Fixed",
            photoURL: nil,
            date: Date().addingTimeInterval(-7200)
        )
    ]

    static let notifications: [AppNotification] = [
        AppNotification(
            title: "Report Update",
            message: "Your Room 202 report is now in progress.",
            time: "10:30 AM",
            type: "update",
            isRead: false
        ),
        AppNotification(
            title: "Report Resolved",
            message: "The Room 203 issue has been fixed.",
            time: "09:15 AM",
            type: "success",
            isRead: true
        ),
        AppNotification(
            title: "Room 204",
            message: "Air conditioning issue was reported.",
            time: "Yesterday, 04:20 PM",
            type: "warning",
            isRead: true
        ),
        AppNotification(
            title: "Report Updated",
            message: "Room 209 report has been updated.",
            time: "Yesterday, 11:10 AM",
            type: "update",
            isRead: true
        )
    ]
}
