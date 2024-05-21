import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .opacity(0.5)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                ProgressView()
                Text("Logging events...")
            }
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .opacity(0.8)
                    .frame(width: 150, height: 150)
            }
        }
    }
}

#Preview {
    LoaderView()
}

