import SwiftUI

struct RoomCard: View {
    
    let room: Room
    
    var body: some View {
        HStack(spacing: 14) {
            
            Image(systemName: "building.2.fill")
                .font(.title3)
                .foregroundStyle(.green)
                .frame(width: 45, height: 45)
                .background(Color.green.opacity(0.1))
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text("Room \(room.number)")
                    .font(.headline)
                
                Text(room.building)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(room.capacity) seats")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            StatusBadge(status: room.status)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(
            RoundedRectangle(cornerRadius: 14)
        )
    }
}
