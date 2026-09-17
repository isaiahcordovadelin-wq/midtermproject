import SwiftUI

struct PrimaryButton: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(Color.green)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
        }
    }
}
