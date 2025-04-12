import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var textOpacity = 0.0
    @State private var logoScale: CGFloat = 0.8

    var body: some View {
        ZStack {
            if isActive {
                WelcomeView() // After Splash, go to Welcome Screen
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.0), value: isActive)
            } else {
                VStack(spacing: 20) {
                    Spacer()

                    Image(systemName: "airplane.circle.fill") // TEMP: You can change later to your logo
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 9/255, green: 29/255, blue: 72/255)) // Dark Blue
                .ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
