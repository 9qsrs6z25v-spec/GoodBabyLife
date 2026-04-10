import SwiftUI

struct TimelineItemView: View {
    let entry: DataStore.TimelineEntry

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            Text(entry.emoji)
                .font(.system(size: 22))
                .frame(width: 42, height: 42)
                .background(entry.isMilk ? Color.babyBlueLight : Color.babyMintLight)
                .clipShape(Circle())

            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.babyText)

                Text(entry.detail)
                    .font(.caption)
                    .foregroundStyle(Color.babyTextLight)
            }

            Spacer()

            // Time
            Text(entry.time)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.babyPinkDark)
        }
        .padding(.vertical, 10)
    }
}
