import SwiftUI

struct SocialLoginButton: View {
    var imageName: String
    var text: String
    var backgroundColor: Color
    var foregroundColor: Color

    var body: some View {
        Button(action: {
            print("\(text) tapped")
        }) {
            HStack(spacing: 10) {
                Image(systemName: imageName)
                Text(text)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SocialLoginButton(
            imageName: "globe",
            text: "Sign Up with Google",
            backgroundColor: .white,
            foregroundColor: .black
        )

        SocialLoginButton(
            imageName: "applelogo",
            text: "Sign In with Apple",
            backgroundColor: .black,
            foregroundColor: .white
        )
    }
    .background(Color(UIColor.systemGroupedBackground))
}
