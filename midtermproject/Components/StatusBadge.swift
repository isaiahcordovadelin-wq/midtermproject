import SwiftUI

struct StatusBadge: View {
    
    let status: String
    
    var body: some View {
        Text(status)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(
                status == "Good" ? .green : .orange
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                (status == "Good" ? Color.green : Color.orange)
                    .opacity(0.12)
            )
            .clipShape(Capsule())
    }
}
