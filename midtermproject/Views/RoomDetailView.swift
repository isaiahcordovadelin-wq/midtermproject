
import SwiftUI

struct RoomDetailView: View {

    let room: Room

    @ObservedObject var roomController: RoomController
    @ObservedObject var reportController: ReportController

    @State private var selectedStatus = "Good"
    @State private var issueDescription = ""

    @State private var showSuccess = false
    @State private var showError = false

    private let availabilityOptions = [
        "Good",
        "Issue",
        "Under Maintenance",
        "Unavailable"
    ]

    private var statusColor: Color {
        switch selectedStatus {
        case "Good":
            return .green
        case "Issue":
            return .orange
        case "Under Maintenance":
            return .blue
        case "Unavailable":
            return .red
        default:
            return .gray
        }
    }

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 22) {

                // ROOM HEADER
                VStack(alignment: .leading, spacing: 16) {

                    HStack {

                        Image(systemName: "building.2.crop.circle.fill")
                            .font(.system(size: 45))
                            .foregroundStyle(.white)

                        Spacer()

                        Text(selectedStatus.uppercased())
                            .font(.caption.bold())
                            .tracking(0.5)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(statusColor)
                            .clipShape(Capsule())
                    }

                    VStack(alignment: .leading, spacing: 5) {

                        Text(room.number)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)

                        Text(room.building)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
                .padding(22)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RPTheme.green)
                .clipShape(RoundedRectangle(cornerRadius: 22))

                // ROOM INFORMATION
                VStack(alignment: .leading, spacing: 16) {

                    sectionTitle(
                        icon: "info.circle.fill",
                        title: "Room Information"
                    )

                    infoRow(
                        title: "Room Number",
                        value: room.number,
                        icon: "door.left.hand.open"
                    )

                    Divider()

                    infoRow(
                        title: "Building",
                        value: room.building,
                        icon: "building.2"
                    )

                    Divider()

                    infoRow(
                        title: "Capacity",
                        value: "\(room.capacity) students",
                        icon: "person.2"
                    )

                    Divider()

                    infoRow(
                        title: "Availability",
                        value: selectedStatus,
                        icon: "checkmark.circle"
                    )

                    Divider()

                    VStack(alignment: .leading, spacing: 7) {

                        Text("Issue Description")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(
                            issueDescription.isEmpty
                            ? "No reported issue"
                            : issueDescription
                        )
                        .font(.subheadline)
                        .foregroundStyle(RPTheme.text)
                    }
                }
                .padding(18)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                // EDIT AVAILABILITY
                VStack(alignment: .leading, spacing: 17) {

                    sectionTitle(
                        icon: "slider.horizontal.3",
                        title: "Edit Room Availability"
                    )

                    Text("Update the room's current availability and condition.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 9) {

                        Text("ROOM STATUS")
                            .font(.caption.bold())
                            .tracking(1)
                            .foregroundStyle(.secondary)

                        Menu {

                            ForEach(availabilityOptions, id: \.self) { status in

                                Button {
                                    selectedStatus = status
                                } label: {

                                    if selectedStatus == status {
                                        Label(status, systemImage: "checkmark")
                                    } else {
                                        Text(status)
                                    }
                                }
                            }

                        } label: {

                            HStack {

                                Circle()
                                    .fill(statusColor)
                                    .frame(width: 10, height: 10)

                                Text(selectedStatus)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(RPTheme.text)

                                Spacer()

                                Image(systemName: "chevron.down")
                                    .foregroundStyle(RPTheme.green)
                            }
                            .padding(15)
                            .background(RPTheme.background)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    VStack(alignment: .leading, spacing: 9) {

                        Text("ISSUE DESCRIPTION / NOTES")
                            .font(.caption.bold())
                            .tracking(1)
                            .foregroundStyle(.secondary)

                        TextEditor(text: $issueDescription)
                            .frame(minHeight: 105)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(RPTheme.background)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button {

                        Task {
                            await saveAvailability()
                        }

                    } label: {

                        HStack(spacing: 9) {

                            if roomController.isUpdating {

                                ProgressView()
                                    .tint(.white)

                                Text("Saving Changes...")

                            } else {

                                Image(systemName: "checkmark.circle.fill")

                                Text("Save Changes")
                                    .fontWeight(.bold)
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(RPTheme.green)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                    }
                    .disabled(roomController.isUpdating)
                }
                .padding(18)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                // REPORT ISSUE
                VStack(alignment: .leading, spacing: 12) {

                    sectionTitle(
                        icon: "exclamationmark.bubble.fill",
                        title: "Report a Problem"
                    )

                    Text("Found a problem in this room? Submit a report to notify the appropriate personnel.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    NavigationLink {

                        ReportView(
                            reportController: reportController,
                            preselectedRoom: room.number
                        )

                    } label: {

                        HStack {

                            Image(systemName: "paperplane.fill")

                            Text("Report This Room Issue")
                                .fontWeight(.bold)

                            Spacer()

                            Image(systemName: "arrow.right")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding(16)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                    }
                }
                .padding(18)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding(20)
        }
        .background(RPTheme.background.ignoresSafeArea())
        .navigationTitle("Room Details")
        .navigationBarTitleDisplayMode(.inline)

        .onAppear {
            selectedStatus = room.status
            issueDescription = room.issue
        }

        .alert("Availability Updated", isPresented: $showSuccess) {

            Button("Done", role: .cancel) { }

        } message: {

            Text("Room \(room.number) has been successfully updated.")
        }

        .alert("Update Failed", isPresented: $showError) {

            Button("OK", role: .cancel) { }

        } message: {

            Text(roomController.errorMessage)
        }
    }

    // MARK: SECTION TITLE

    private func sectionTitle(
        icon: String,
        title: String
    ) -> some View {

        HStack(spacing: 10) {

            Image(systemName: icon)
                .foregroundStyle(RPTheme.green)
                .font(.system(size: 18))

            Text(title)
                .font(.headline)
                .foregroundStyle(RPTheme.text)
        }
    }

    // MARK: INFORMATION ROW

    private func infoRow(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundStyle(RPTheme.green)
                .frame(width: 22)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(RPTheme.text)
                .multilineTextAlignment(.trailing)
        }
    }

    // MARK: SAVE AVAILABILITY

    @MainActor
    private func saveAvailability() async {

        let success = await roomController.updateRoomAvailability(
            roomID: room.id,
            status: selectedStatus,
            issueDescription: issueDescription
        )

        if success {
            showSuccess = true
        } else {
            showError = true
        }
    }
}
