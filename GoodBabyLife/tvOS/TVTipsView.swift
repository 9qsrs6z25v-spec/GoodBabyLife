import SwiftUI

struct TVTipsView: View {
    private let columns = [
        GridItem(.flexible(), spacing: 30),
        GridItem(.flexible(), spacing: 30),
    ]

    private let borderColors: [Color] = [
        .babyPink, .babyMint, .babyBlue,
        .babyPeach, .babyLavender, .babyYellow,
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 8) {
                    Text("💡 可愛小建議")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("給爸爸媽媽的溫馨提醒 💕")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 20)

                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(Array(BabyTip.allTips.enumerated()), id: \.element.id) { index, tip in
                        TVTipCard(
                            tip: tip,
                            borderColor: borderColors[index % borderColors.count]
                        )
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(.bottom, 60)
        }
    }
}

struct TVTipCard: View {
    let tip: BabyTip
    let borderColor: Color

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Text(tip.emoji)
                .font(.system(size: 50))

            VStack(alignment: .leading, spacing: 8) {
                Text(tip.title)
                    .font(.title3)
                    .fontWeight(.bold)

                Text(tip.text)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)

                Text(tip.category.label)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(categoryBgColor)
                    .clipShape(Capsule())
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(alignment: .top) {
            borderColor
                .frame(height: 4)
                .clipShape(RoundedRectangle(cornerRadius: 2))
        }
    }

    private var categoryBgColor: Color {
        switch tip.category {
        case .milk: return .babyBlueLight
        case .food: return .babyMintLight
        case .sleep: return .babyLavenderLight
        case .general: return .babyPeachLight
        }
    }
}

#Preview {
    TVTipsView()
}
