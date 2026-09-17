import SwiftUI

struct StatusBadge: View {
    let status: String

    private var color: Color {
        switch status {
        case "Good", "Fixed", "Resolved":
            return .green
        case "Issue", "In Progress":
            return .orange
        case "Reported", "Pending":
            return .blue
        default:
            return .gray
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)

            Text(status)
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(color.opacity(0.10))
        .clipShape(Capsule())
    }
}
