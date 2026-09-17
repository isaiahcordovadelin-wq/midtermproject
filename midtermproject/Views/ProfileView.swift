import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var reportController: ReportController
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    Image(
                        systemName: "person.circle.fill"
                    )
                    .font(.system(size: 80))
                    .foregroundStyle(.green)
                    
                    Text("Student User")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Information Technology")
                        .foregroundStyle(.secondary)
                    
                    
                    VStack(spacing: 0) {
                        
                        ProfileRow(
                            title: "Reports Submitted",
                            value: "\(reportController.totalReports)"
                        )
                        
                        Divider()
                        
                        ProfileRow(
                            title: "Resolved Reports",
                            value: "\(reportController.resolvedReports)"
                        )
                        
                        Divider()
                        
                        ProfileRow(
                            title: "Active Reports",
                            value: "\(reportController.activeReports)"
                        )
                    }
                    .padding()
                    .background(
                        Color(.secondarySystemBackground)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
                    
                    
                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {
                        
                        Text("About RoomPulse")
                            .font(.headline)
                        
                        Text(
                            "RoomPulse helps students report classroom problems and check room conditions."
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
                        RoundedRectangle(cornerRadius: 15)
                    )
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}


struct ProfileRow: View {
    
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            
            Text(title)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(.green)
        }
        .padding(.vertical, 8)
    }
}
