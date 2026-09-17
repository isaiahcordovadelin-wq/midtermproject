import SwiftUI

struct RoomVisual: View {
    let room: Room

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    Color.green.opacity(0.18),
                    Color.green.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: "building.2.fill")
                .font(.system(size: 45))
                .foregroundStyle(.green)
                .padding(20)

            VStack {
                Spacer()

                HStack {
                    Text("ROOM \(room.number)")
                        .font(.caption)
                        .fontWeight(.bold)

                    Spacer()
                }
                .padding(12)
                .background(.ultraThinMaterial)
            }
        }
        .frame(height: 150)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}
