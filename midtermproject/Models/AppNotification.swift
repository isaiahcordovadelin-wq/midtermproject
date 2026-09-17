import Foundation

struct AppNotification: Identifiable {
    let id = UUID()

    let title: String
    let message: String
    let time: String
    let type: String
    let isRead: Bool
}
