import SwiftUI

struct TipsView: View {
    private let borderColors: [Color] = [
        .babyPink, .babyMint, .babyBlue,
        .babyPeach, .babyLavender, .babyYellow,
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 4) {
                    Text("💡 可愛小建議")
                        .font(.headline)
                    Text("給爸爸媽媽的溫馨提醒 💕")
                        .font(.subheadline)
                        .foregroundStyle(Color.babyTextLight)
                }
                .frame(maxWidth: .infinity)
                .babyCard()

                // Tip Cards
                ForEach(Array(BabyTip.allTips.enumerated()), id: \.element.id) { index, tip in
                    TipCardView(
                        tip: tip,
                        borderColor: borderColors[index % borderColors.count]
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color.babyBg)
        .navigationTitle("💡 小建議")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

#Preview {
    NavigationStack {
        TipsView()
    }
}
