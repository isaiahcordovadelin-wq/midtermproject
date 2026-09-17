import SwiftUI

struct ContentView: View {
    
    @StateObject private var roomController =
        RoomController()
    
    @StateObject private var reportController =
        ReportController()
    
    var body: some View {
        
        TabView {
            
            HomeView(
                roomController: roomController,
                reportController: reportController
            )
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            
            RoomsView(
                roomController: roomController
            )
            .tabItem {
                Image(systemName: "building.2.fill")
                Text("Rooms")
            }
            
            
            ReportView(
                reportController: reportController
            )
            .tabItem {
                Image(
                    systemName:
                        "exclamationmark.triangle.fill"
                )
                Text("Report")
            }
            
            
            ProfileView(
                reportController: reportController
            )
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .tint(.green)
    }
}

#Preview {
    ContentView()
}
