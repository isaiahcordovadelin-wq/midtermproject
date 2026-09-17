import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appController: AppController

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.green,
                    Color.green.opacity(0.75)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "building.2.crop.circle.fill")
                    .font(.system(size: 85))
                    .foregroundStyle(.white)

                Text("RoomPulse")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(.white)

                Text("Campus Room Monitor")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 1.5
            ) {
                withAnimation {
                    appController.showSplash = false
                }
            }
        }
    }
}
