import SwiftUI

struct StatCardView: View {
    let icon: String
    let value: String
    let label: String
    let accentColor: Color

    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 28))

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color.babyText)

                Text(label)
                    .font(.caption2)
                    .foregroundStyle(Color.babyTextLight)
            }

            Spacer()
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 0.5)
                .stroke(accentColor.opacity(0.3), lineWidth: 1)
        )
        .overlay(alignment: .leading) {
            accentColor
                .frame(width: 4)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .padding(.vertical, 8)
        }
        .shadow(color: Color.babyPink.opacity(0.15), radius: 6, y: 3)
    }
}

#Preview {
    VStack {
        StatCardView(icon: "🍼", value: "3", label: "今日喝奶次數", accentColor: .babyBlue)
        StatCardView(icon: "🥣", value: "2", label: "今日副食品", accentColor: .babyMint)
    }
    .padding()
    .background(Color.babyBg)
}
