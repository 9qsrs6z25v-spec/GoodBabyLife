import SwiftUI

struct TipCardView: View {
    let tip: BabyTip
    var borderColor: Color = .babyPink

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(tip.emoji)
                .font(.system(size: 36))

            VStack(alignment: .leading, spacing: 6) {
                Text(tip.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.babyText)

                Text(tip.text)
                    .font(.caption)
                    .foregroundStyle(Color.babyTextLight)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)

                Text(tip.category.label)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(categoryBgColor)
                    .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .top) {
            borderColor
                .frame(height: 3)
                .clipShape(RoundedRectangle(cornerRadius: 2))
        }
        .shadow(color: Color.babyPink.opacity(0.15), radius: 6, y: 3)
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
    TipCardView(tip: BabyTip.allTips[0])
        .padding()
        .background(Color.babyBg)
}
