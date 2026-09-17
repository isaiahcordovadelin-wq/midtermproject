import SwiftUI

struct RoomsView: View {
    
    @ObservedObject var roomController: RoomController
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {
                    
                    VStack(
                        alignment: .leading,
                        spacing: 5
                    ) {
                        
                        Text("Rooms")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(
                            "View the current condition of campus rooms."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    
                    ForEach(roomController.rooms) { room in
                        
                        NavigationLink {
                            RoomDetailView(room: room)
                        } label: {
                            RoomCard(room: room)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}


// MARK: Room Detail

struct RoomDetailView: View {
    
    let room: Room
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 20
        ) {
            
            HStack(spacing: 15) {
                
                Image(systemName: "building.2.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                    .frame(width: 70, height: 70)
                    .background(
                        Color.green.opacity(0.1)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
                
                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {
                    
                    Text("Room \(room.number)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(room.building)
                        .foregroundStyle(.secondary)
                    
                    StatusBadge(status: room.status)
                }
            }
            
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                
                Text("Room Information")
                    .font(.headline)
                
                DetailRow(
                    title: "Capacity",
                    value: "\(room.capacity) students"
                )
                
                DetailRow(
                    title: "Status",
                    value: room.status
                )
                
                DetailRow(
                    title: "Current Issue",
                    value: room.issue
                )
            }
            .padding()
            .background(
                Color(.secondarySystemBackground)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 15)
            )
            
            Spacer()
        }
        .padding()
        .navigationTitle("Room Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct DetailRow: View {
    
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            
            Text(title)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
    }
}
