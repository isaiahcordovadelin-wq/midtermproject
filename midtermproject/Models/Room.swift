import Foundation

struct Room: Identifiable {
    let id = UUID()
    
    let number: String
    let building: String
    let capacity: Int
    let status: String
    let issue: String
}
