import Foundation
import Combine

class ReportController: ObservableObject {
    
    @Published var reports: [RoomReport] = SampleData.reports
    
    func addReport(
        room: String,
        category: String,
        description: String
    ) {
        let newReport = RoomReport(
            room: room,
            category: category,
            description: description,
            status: "Reported"
        )
        
        reports.insert(newReport, at: 0)
    }
    
    var totalReports: Int {
        reports.count
    }
    
    var activeReports: Int {
        reports.filter {
            $0.status != "Fixed"
        }.count
    }
    
    var resolvedReports: Int {
        reports.filter {
            $0.status == "Fixed"
        }.count
    }
}
