import SwiftUI

struct RoomCard: View {
    let room: Room

    private var statusColor: Color {
        room.status == "Good" ? .green : .orange
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(RPTheme.lightGreen)

                Image(systemName: "door.left.hand.open")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(RPTheme.green)
            }
            .frame(width: 55, height: 55)

            VStack(alignment: .leading, spacing: 5) {
                Text("Room \(room.number)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(RPTheme.text)

                Text(room.building)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 5) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 10))

                    Text("\(room.capacity) seats")
                        .font(.caption2)
                }
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 4)

            VStack(alignment: .trailing, spacing: 9) {
                StatusBadge(status: room.status)

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(15)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
