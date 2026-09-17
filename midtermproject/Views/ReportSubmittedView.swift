import SwiftUI

struct ReportSubmittedView: View {
    let report: RoomReport

    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 130, height: 130)

                Circle()
                    .fill(Color.green)
                    .frame(width: 90, height: 90)

                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
            }

            Text("Report Submitted!")
                .font(.title)
                .fontWeight(.bold)

            Text("Your report has been successfully recorded.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(
                alignment: .leading,
                spacing: 14
            ) {
                DetailRow(
                    title: "Room",
                    value: report.room
                )

                Divider()

                DetailRow(
                    title: "Issue",
                    value: report.category
                )

                Divider()

                DetailRow(
                    title: "Status",
                    value: report.status
                )
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 15))

            Spacer()

            NavigationLink {
                Text("Report submitted successfully.")
                    .navigationTitle("Done")
            } label: {
                Text("Done")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

struct DetailRow: View {

    let title: String
    let value: String

    var body: some View {

        HStack(alignment: .top) {

            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Text(value.isEmpty ? "Not specified" : value)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}
