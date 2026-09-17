import SwiftUI

struct HomeView: View {
    
    @ObservedObject var roomController: RoomController
    @ObservedObject var reportController: ReportController
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Logo
                    
                    HStack(spacing: 10) {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green)
                                .frame(width: 42, height: 42)
                            
                            Image(systemName: "building.2.fill")
                                .foregroundStyle(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            
                            Text("ROOMPULSE")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("Campus Room Monitor")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Welcome
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Welcome!")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Check the current room status.")
                            .foregroundStyle(.secondary)
                    }
                    
                    // Statistics
                    
                    HStack(spacing: 10) {
                        
                        SummaryBox(
                            number: "\(roomController.totalRooms)",
                            title: "Rooms"
                        )
                        
                        SummaryBox(
                            number: "\(roomController.goodRooms)",
                            title: "Good"
                        )
                        
                        SummaryBox(
                            number: "\(roomController.issueRooms)",
                            title: "Issues"
                        )
                    }
                    
                    // Recent Reports
                    
                    Text("Recent Reports")
                        .font(.headline)
                    
                    VStack(spacing: 10) {
                        
                        ForEach(
                            reportController.reports.prefix(3)
                        ) { report in
                            
                            HStack {
                                
                                Image(
                                    systemName:
                                        "exclamationmark.triangle.fill"
                                )
                                .foregroundStyle(.orange)
                                
                                VStack(
                                    alignment: .leading,
                                    spacing: 3
                                ) {
                                    
                                    Text("Room \(report.room)")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    Text(report.category)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(report.status)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(
                                Color(.secondarySystemBackground)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                        }
                    }
                    
                    // About
                    
                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {
                        
                        Text("RoomPulse")
                            .font(.headline)
                        
                        Text(
                            "A simple room monitoring and reporting application for campus facilities."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(
                        Color.green.opacity(0.08)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct SummaryBox: View {
    
    let number: String
    let title: String
    
    var body: some View {
        VStack(spacing: 5) {
            
            Text(number)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
}
