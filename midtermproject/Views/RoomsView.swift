
import SwiftUI

struct RoomsView: View {

    @ObservedObject var roomController: RoomController
    @ObservedObject var reportController: ReportController

    @State private var searchText = ""
    @State private var selectedFilter = "All"

    private let filters = [
        "All",
        "Good",
        "Issue",
        "Under Maintenance",
        "Unavailable"
    ]

    private var filteredRooms: [Room] {
        roomController.rooms.filter { room in

            let matchesSearch =
                searchText.isEmpty ||
                room.number.localizedCaseInsensitiveContains(searchText) ||
                room.building.localizedCaseInsensitiveContains(searchText)

            let matchesFilter =
                selectedFilter == "All" ||
                room.status == selectedFilter

            return matchesSearch && matchesFilter
        }
    }

    var body: some View {

        NavigationStack {

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 20) {

                    // HEADER
                    VStack(alignment: .leading, spacing: 5) {

                        Text("Room Availability")
                            .font(.system(size: 27, weight: .bold))
                            .foregroundStyle(RPTheme.text)

                        Text("Check the availability and condition of campus rooms.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // SUMMARY
                    HStack {

                        VStack(alignment: .leading, spacing: 5) {

                            Text("TOTAL REGISTERED ROOMS")
                                .font(.caption2.bold())
                                .tracking(1)
                                .foregroundStyle(.white.opacity(0.8))

                            Text("\(roomController.totalRooms)")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundStyle(.white)

                            Text("Campus room directory")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                        }

                        Spacer()

                        Image(systemName: "building.2.crop.circle.fill")
                            .font(.system(size: 55))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(20)
                    .background(RPTheme.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // STATUS SUMMARY
                    HStack(spacing: 10) {

                        summaryCard(
                            title: "Good",
                            count: roomController.goodRooms,
                            color: .green
                        )

                        summaryCard(
                            title: "Issues",
                            count: roomController.issueRooms,
                            color: .orange
                        )

                        summaryCard(
                            title: "Unavailable",
                            count: roomController.unavailableRooms,
                            color: .red
                        )
                    }

                    // SEARCH
                    HStack {

                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)

                        TextField(
                            "Search room or building...",
                            text: $searchText
                        )
                        .textInputAutocapitalization(.never)

                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(14)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    // FILTERS
                    VStack(alignment: .leading, spacing: 10) {

                        Text("Filter by Availability")
                            .font(.headline)
                            .foregroundStyle(RPTheme.text)

                        ScrollView(.horizontal, showsIndicators: false) {

                            HStack(spacing: 9) {

                                ForEach(filters, id: \.self) { filter in

                                    Button {
                                        selectedFilter = filter
                                    } label: {

                                        Text(filter)
                                            .font(.caption.bold())
                                            .foregroundStyle(
                                                selectedFilter == filter
                                                ? .white
                                                : RPTheme.text
                                            )
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedFilter == filter
                                                ? RPTheme.green
                                                : .white
                                            )
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // ROOM LIST
                    HStack {

                        VStack(alignment: .leading, spacing: 4) {

                            Text("CCMS Rooms")
                                .font(.headline)
                                .foregroundStyle(RPTheme.text)

                            Text("College of Computer and Multimedia Studies")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text("\(filteredRooms.count) rooms")
                            .font(.caption.bold())
                            .foregroundStyle(RPTheme.green)
                    }

                    if roomController.isLoading {

                        ProgressView("Loading rooms...")
                            .frame(maxWidth: .infinity)
                            .padding()

                    } else if !roomController.errorMessage.isEmpty &&
                                roomController.rooms.isEmpty {

                        VStack(spacing: 10) {

                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundStyle(.orange)

                            Text("Unable to load rooms")
                                .font(.headline)

                            Text(roomController.errorMessage)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            Button("Try Again") {
                                Task {
                                    await roomController.fetchRooms()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(RPTheme.green)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()

                    } else if filteredRooms.isEmpty {

                        ContentUnavailableView(
                            "No Rooms Found",
                            systemImage: "building.2",
                            description: Text("No rooms match your search or selected filter.")
                        )
                        .padding(.vertical, 20)

                    } else {

                        LazyVStack(spacing: 12) {

                            ForEach(filteredRooms) { room in

                                NavigationLink {

                                    RoomDetailView(
                                        room: room,
                                        roomController: roomController,
                                        reportController: reportController
                                    )

                                } label: {

                                    RoomCard(room: room)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(
                RPTheme.background.ignoresSafeArea()
            )
            .toolbar(.hidden, for: .navigationBar)
            .refreshable {
                await roomController.fetchRooms()
            }
        }
    }

    private func summaryCard(
        title: String,
        count: Int,
        color: Color
    ) -> some View {

        VStack(alignment: .leading, spacing: 7) {

            Text("\(count)")
                .font(.title2.bold())
                .foregroundStyle(RPTheme.text)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .background(.white)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(color)
                .frame(height: 4)
        }
        .clipShape(RoundedRectangle(cornerRadius: 13))
    }
}
