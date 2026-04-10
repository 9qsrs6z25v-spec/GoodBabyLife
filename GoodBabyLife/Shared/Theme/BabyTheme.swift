import SwiftUI

// MARK: - Baby Pastel Colors

extension Color {
    static let babyPink = Color(red: 1.0, green: 0.71, blue: 0.76)
    static let babyPinkLight = Color(red: 1.0, green: 0.94, blue: 0.95)
    static let babyPinkDark = Color(red: 1.0, green: 0.56, blue: 0.67)
    static let babyLavender = Color(red: 0.90, green: 0.90, blue: 0.98)
    static let babyLavenderLight = Color(red: 0.96, green: 0.95, blue: 1.0)
    static let babyMint = Color(red: 0.71, green: 0.92, blue: 0.84)
    static let babyMintLight = Color(red: 0.91, green: 1.0, blue: 0.96)
    static let babyPeach = Color(red: 1.0, green: 0.85, blue: 0.73)
    static let babyPeachLight = Color(red: 1.0, green: 0.96, blue: 0.92)
    static let babyBlue = Color(red: 0.68, green: 0.85, blue: 0.94)
    static let babyBlueLight = Color(red: 0.92, green: 0.96, blue: 0.98)
    static let babyYellow = Color(red: 1.0, green: 0.92, blue: 0.65)
    static let babyYellowLight = Color(red: 1.0, green: 0.99, blue: 0.91)
    static let babyBg = Color(red: 1.0, green: 0.97, blue: 0.98)
    static let babyText = Color(red: 0.35, green: 0.29, blue: 0.35)
    static let babyTextLight = Color(red: 0.54, green: 0.48, blue: 0.54)
}

// MARK: - Card Style Modifier

struct BabyCardStyle: ViewModifier {
    var padding: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.babyPink.opacity(0.2), radius: 8, y: 4)
    }
}

extension View {
    func babyCard(padding: CGFloat = 20) -> some View {
        modifier(BabyCardStyle(padding: padding))
    }
}

// MARK: - Gradient Backgrounds

struct BabyGradient {
    static let header = LinearGradient(
        colors: [.babyPink, .babyLavender, .babyBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let milkButton = LinearGradient(
        colors: [.babyBlue, .babyLavender],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let foodButton = LinearGradient(
        colors: [.babyMint, .babyBlue],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let welcome = LinearGradient(
        colors: [.babyPinkLight, .babyLavenderLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let tipHighlight = LinearGradient(
        colors: [.babyYellowLight, .babyPeachLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Bouncing Animation

struct BounceEffect: ViewModifier {
    @State private var animating = false

    func body(content: Content) -> some View {
        content
            .offset(y: animating ? -6 : 0)
            .animation(
                .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                value: animating
            )
            .onAppear { animating = true }
    }
}

extension View {
    func bounceEffect() -> some View {
        modifier(BounceEffect())
    }
}

// MARK: - Pulse Animation

struct PulseEffect: ViewModifier {
    @State private var animating = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(animating ? 1.08 : 1.0)
            .animation(
                .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                value: animating
            )
            .onAppear { animating = true }
    }
}

extension View {
    func pulseEffect() -> some View {
        modifier(PulseEffect())
    }
}
