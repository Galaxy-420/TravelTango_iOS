import SwiftUI

struct SplashView: View {
    @Binding var isSplashFinished: Bool
    @State private var textOpacity = 0.0
    @State private var logoScale: CGFloat = 0.8

    var body: some View {
        ZStack {
            // 🌌 Dark Blue Background
            Color(red: 9/255, green: 29/255, blue: 72/255)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // ✈️ Logo
                Image(systemName: "airplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .scaleEffect(logoScale)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.5)) {
                            logoScale = 1.0
                        }
                    }

                // ✨ App Title
                Text("TravelTango")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 2.0)) {
                            textOpacity = 1.0
                        }
                    }

                Spacer()
            }
        }
        .onAppear {
            // ⏳ Delay before moving to Sign In or Dashboard
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    isSplashFinished = true
                }
            }
        }
    }
}
