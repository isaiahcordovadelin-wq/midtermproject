
import SwiftUI

struct ContentView: View {

    @StateObject private var appController = AppController()
    @StateObject private var roomController = RoomController()
    @StateObject private var reportController = ReportController()

    var body: some View {

        Group {
            if appController.showSplash {
                SplashView()
            } else if !appController.isLoggedIn {
                LoginView()
            } else if appController.userRole == "admin" {
                AdminTabView(
                    roomController: roomController,
                    reportController: reportController
                )
            } else {
                MainTabView(
                    roomController: roomController,
                    reportController: reportController
                )
            }
        }
        .environmentObject(appController)
        .environmentObject(roomController)
        .environmentObject(reportController)
        .preferredColorScheme(.light)
        .task {
            await appController.checkSession()
            appController.showSplash = false
        }
        .onChange(of: appController.isLoggedIn) { _, loggedIn in
            if loggedIn {
                Task {
                    await roomController.fetchRooms()

                    if appController.userRole == "admin" {
                        await reportController.fetchAllReports()
                    } else {
                        await reportController.fetchReports()
                    }
                }
            }
        }
    }
}

// MARK: - STUDENT TABS

struct MainTabView: View {

    @ObservedObject var roomController: RoomController
    @ObservedObject var reportController: ReportController

    var body: some View {

        TabView {

            HomeView(
                roomController: roomController,
                reportController: reportController
            )
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            RoomsView(
                roomController: roomController,
                reportController: reportController
            )
            .tabItem {
                Label("Rooms", systemImage: "building.2.fill")
            }

            NavigationStack {
                ReportView(
                    reportController: reportController
                )
            }
            .tabItem {
                Label("Report", systemImage: "plus.app.fill")
            }

            ProfileView(
                reportController: reportController
            )
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
        }
        .tint(RPTheme.green)
    }
}

// MARK: - ROOM PULSE THEME

enum RPTheme {

    static let green = Color(
        red: 23.0 / 255.0,
        green: 107.0 / 255.0,
        blue: 69.0 / 255.0
    )

    static let lightGreen = Color(
        red: 232.0 / 255.0,
        green: 242.0 / 255.0,
        blue: 235.0 / 255.0
    )

    static let background = Color(
        red: 247.0 / 255.0,
        green: 249.0 / 255.0,
        blue: 247.0 / 255.0
    )

    static let text = Color(
        red: 35.0 / 255.0,
        green: 45.0 / 255.0,
        blue: 39.0 / 255.0
    )

    static let secondaryText = Color.gray
}
