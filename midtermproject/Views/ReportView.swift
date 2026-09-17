
import SwiftUI

struct ReportView: View {

    @ObservedObject var reportController: ReportController
    @EnvironmentObject var roomController: RoomController

    var preselectedRoom: String? = nil

    @State private var selectedRoom = ""
    @State private var selectedCategory = "Furniture"
    @State private var newDescription = ""

    @State private var isSubmitting = false
    @State private var showSuccess = false
    @State private var showError = false

    private let categories: [(name: String, icon: String)] = [
        ("Furniture", "chair.lounge.fill"),
        ("Projector", "projector.fill"),
        ("Air Conditioning", "snowflake"),
        ("Electrical", "bolt.fill"),
        ("Cleanliness", "sparkles"),
        ("Other", "ellipsis.circle.fill")
    ]

    private var sortedRooms: [Room] {
        roomController.rooms.sorted {
            if $0.building == $1.building {
                return $0.number < $1.number
            }
            return $0.building < $1.building
        }
    }

    private var selectedRoomDetails: Room? {
        sortedRooms.first {
            $0.number == selectedRoom
        }
    }

    private var isFormValid: Bool {
        !selectedRoom.isEmpty &&
        !newDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 22) {

                // HEADER
                headerSection

                // ROOM SELECTION
                roomSelectionSection

                // ISSUE CATEGORY
                categorySection

                // DESCRIPTION
                descriptionSection

                // SUBMIT BUTTON
                submitButton

                // FOOTER
                HStack(spacing: 7) {
                    Image(systemName: "lock.shield.fill")

                    Text("Your report will be submitted to the RoomPulse system.")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
            }
            .padding(20)
        }
        .background(RPTheme.background.ignoresSafeArea())
        .navigationTitle("Submit Report")
        .navigationBarTitleDisplayMode(.inline)

        .onAppear {
            selectPreselectedRoom()
        }

        .onChange(of: newDescription) { _, newValue in
            if newValue.count > 500 {
                newDescription = String(newValue.prefix(500))
            }
        }

        .alert("Report Submitted", isPresented: $showSuccess) {
            Button("Done", role: .cancel) {
                selectedRoom = preselectedRoomValue()
                selectedCategory = "Furniture"
                newDescription = ""
            }
        } message: {
            Text("Your report has been successfully submitted.")
        }

        .alert("Submission Failed", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(
                reportController.errorMessage.isEmpty
                ? "Something went wrong. Please try again."
                : reportController.errorMessage
            )
        }
    }

    // MARK: HEADER

    private var headerSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            HStack(alignment: .center) {

                VStack(alignment: .leading, spacing: 7) {

                    Text("REPORT AN ISSUE")
                        .font(.caption.bold())
                        .tracking(2)
                        .foregroundStyle(RPTheme.green)

                    Text("Submit a Report")
                        .font(.system(size: 29, weight: .bold))
                        .foregroundStyle(RPTheme.text)

                    Text("Help us maintain a safe and comfortable campus.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 34))
                    .foregroundStyle(.white)
                    .frame(width: 72, height: 72)
                    .background(RPTheme.green)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
            }

            HStack(spacing: 8) {

                Image(systemName: "info.circle.fill")

                Text("Please provide accurate information about the issue.")
            }
            .font(.caption)
            .foregroundStyle(RPTheme.green)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RPTheme.green.opacity(0.09))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: ROOM SELECTION

    private var roomSelectionSection: some View {

        VStack(alignment: .leading, spacing: 16) {

            sectionHeader(
                icon: "location.fill",
                title: "Room Information",
                subtitle: "Select the room where you noticed the problem"
            )

            VStack(alignment: .leading, spacing: 9) {

                Text("ROOM / FACILITY")
                    .font(.caption.bold())
                    .tracking(1)
                    .foregroundStyle(.secondary)

                Menu {

                    ForEach(sortedRooms) { room in

                        Button {
                            selectedRoom = room.number
                        } label: {

                            if selectedRoom == room.number {
                                Label(
                                    "\(room.number) — \(room.building)",
                                    systemImage: "checkmark"
                                )
                            } else {
                                Text("\(room.number) — \(room.building)")
                            }
                        }
                    }

                } label: {

                    HStack(spacing: 12) {

                        Image(systemName: "building.2.fill")
                            .font(.system(size: 19))
                            .foregroundStyle(RPTheme.green)

                        VStack(alignment: .leading, spacing: 4) {

                            Text(
                                selectedRoomDetails.map {
                                    "\($0.number) — \($0.building)"
                                } ?? "Choose a room"
                            )
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(
                                selectedRoom.isEmpty
                                ? .secondary
                                : RPTheme.text
                            )

                            Text(
                                selectedRoom.isEmpty
                                ? "\(sortedRooms.count) registered rooms"
                                : "Selected facility"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(RPTheme.green)
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RPTheme.background)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .overlay {
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(
                                selectedRoom.isEmpty
                                ? Color.gray.opacity(0.2)
                                : RPTheme.green.opacity(0.5),
                                lineWidth: 1
                            )
                    }
                }
                .disabled(sortedRooms.isEmpty)

                if sortedRooms.isEmpty {

                    HStack(spacing: 7) {
                        Image(systemName: "exclamationmark.circle.fill")

                        Text("No rooms found. Please check your room database.")
                    }
                    .font(.caption)
                    .foregroundStyle(.orange)

                } else {

                    Text("Select from the registered campus rooms.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: CATEGORY

    private var categorySection: some View {

        VStack(alignment: .leading, spacing: 16) {

            sectionHeader(
                icon: "square.grid.2x2.fill",
                title: "Issue Category",
                subtitle: "Choose the type of problem"
            )

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 11
            ) {

                ForEach(categories, id: \.name) { category in

                    categoryCard(
                        name: category.name,
                        icon: category.icon
                    )
                }
            }
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: DESCRIPTION

    private var descriptionSection: some View {

        VStack(alignment: .leading, spacing: 15) {

            sectionHeader(
                icon: "text.alignleft",
                title: "Describe the Issue",
                subtitle: "Provide details about the problem"
            )

            VStack(alignment: .leading, spacing: 8) {

                Text("DESCRIPTION")
                    .font(.caption.bold())
                    .tracking(1)
                    .foregroundStyle(.secondary)

                ZStack(alignment: .topLeading) {

                    if newDescription.isEmpty {

                        Text("Describe what happened, where it happened, and any other important details...")
                            .font(.subheadline)
                            .foregroundStyle(.gray.opacity(0.7))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 16)
                    }

                    TextEditor(text: $newDescription)
                        .scrollContentBackground(.hidden)
                        .padding(7)
                        .frame(minHeight: 145)
                        .opacity(newDescription.isEmpty ? 0.25 : 1)
                }
                .background(RPTheme.background)
                .clipShape(RoundedRectangle(cornerRadius: 13))

                HStack {

                    Text("Be as specific as possible.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\(newDescription.count)/500")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: SUBMIT BUTTON

    private var submitButton: some View {

        Button {

            Task {
                await submitReport()
            }

        } label: {

            HStack(spacing: 10) {

                if isSubmitting {

                    ProgressView()
                        .tint(.white)

                    Text("Submitting Report...")

                } else {

                    Image(systemName: "paperplane.fill")

                    Text("Submit Report")
                        .fontWeight(.bold)
                }
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                isFormValid ? RPTheme.green : Color.gray
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!isFormValid || isSubmitting)
    }

    // MARK: SECTION HEADER

    private func sectionHeader(
        icon: String,
        title: String,
        subtitle: String
    ) -> some View {

        HStack(spacing: 11) {

            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(RPTheme.green)
                .frame(width: 40, height: 40)
                .background(RPTheme.green.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 3) {

                Text(title)
                    .font(.headline)
                    .foregroundStyle(RPTheme.text)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: CATEGORY CARD

    private func categoryCard(
        name: String,
        icon: String
    ) -> some View {

        let isSelected = selectedCategory == name

        return Button {

            selectedCategory = name

        } label: {

            HStack(spacing: 9) {

                Image(systemName: icon)
                    .font(.system(size: 17))
                    .frame(width: 23)

                Text(name)
                    .font(.caption.bold())
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                }
            }
            .foregroundStyle(
                isSelected ? .white : RPTheme.text
            )
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 57)
            .background(
                isSelected ? RPTheme.green : RPTheme.background
            )
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .overlay {
                RoundedRectangle(cornerRadius: 13)
                    .stroke(
                        isSelected ? RPTheme.green : Color.clear,
                        lineWidth: 1.5
                    )
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: PRESELECTED ROOM

    private func preselectedRoomValue() -> String {

        guard let preselectedRoom else {
            return ""
        }

        let value = preselectedRoom
            .replacingOccurrences(of: "Room ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return sortedRooms.first {
            $0.number == value
        }?.number ?? ""
    }

    private func selectPreselectedRoom() {

        guard let preselectedRoom else {
            return
        }

        selectedRoom = preselectedRoomValue()
    }

    // MARK: SUBMIT REPORT

    @MainActor
    private func submitReport() async {

        guard isFormValid else { return }

        isSubmitting = true
        defer {
            isSubmitting = false
        }

        await reportController.addReport(
            room: selectedRoom,
            category: selectedCategory,
            description: newDescription.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        )

        if reportController.errorMessage.isEmpty {
            showSuccess = true
        } else {
            showError = true
        }
    }
}
