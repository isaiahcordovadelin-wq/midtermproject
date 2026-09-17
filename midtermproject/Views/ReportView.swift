import SwiftUI

struct ReportView: View {
    
    @ObservedObject var reportController: ReportController
    
    @State private var selectedRoom = "Room 201"
    @State private var selectedCategory = "Projector"
    @State private var description = ""
    @State private var showSuccess = false
    
    let rooms = [
        "Room 201",
        "Room 202",
        "Room 203",
        "Room 204",
        "Room 301",
        "Room 302"
    ]
    
    let categories = [
        "Projector",
        "Air Conditioning",
        "Lights",
        "Furniture",
        "Cleanliness",
        "Electrical",
        "Other"
    ]
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                Section("Room") {
                    
                    Picker(
                        "Select Room",
                        selection: $selectedRoom
                    ) {
                        
                        ForEach(
                            rooms,
                            id: \.self
                        ) { room in
                            Text(room)
                        }
                    }
                }
                
                Section("Issue Category") {
                    
                    Picker(
                        "Select Category",
                        selection: $selectedCategory
                    ) {
                        
                        ForEach(
                            categories,
                            id: \.self
                        ) { category in
                            Text(category)
                        }
                    }
                }
                
                Section("Description") {
                    
                    TextField(
                        "Describe the problem...",
                        text: $description,
                        axis: .vertical
                    )
                    .lineLimit(5)
                }
                
                Section {
                    
                    Button {
                        
                        reportController.addReport(
                            room: selectedRoom,
                            category: selectedCategory,
                            description: description
                        )
                        
                        showSuccess = true
                        
                    } label: {
                        
                        HStack {
                            Spacer()
                            
                            Text("Submit Report")
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                    }
                    .disabled(description.isEmpty)
                }
            }
            .navigationTitle("Report Issue")
            .alert(
                "Report Submitted",
                isPresented: $showSuccess
            ) {
                
                Button("OK") {
                    description = ""
                }
                
            } message: {
                
                Text(
                    "Your report for \(selectedRoom) has been submitted."
                )
            }
        }
    }
}
