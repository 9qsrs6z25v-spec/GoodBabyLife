import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \MilkRecord.date, order: .reverse) private var allMilk: [MilkRecord]
    @Query(sort: \FoodRecord.date, order: .reverse) private var allFood: [FoodRecord]

    private var todayMilk: [MilkRecord] { allMilk.today }
    private var todayFood: [FoodRecord] { allFood.today }
    private var timeline: [TimelineEntry] { buildTimeline(milk: allMilk, food: allFood) }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                welcomeCard
                statsGrid
                timelineSection
                dailyTipCard
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color.babyBg)
        .navigationTitle("👶 Good Baby Life")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }

    private var welcomeCard: some View {
        VStack(spacing: 8) {
            Text("🌟")
                .font(.system(size: 48))
                .pulseEffect()
            Text("今日寶寶日誌")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.babyText)
            Text(welcomeMessage(milkCount: todayMilk.count, foodCount: todayFood.count))
                .font(.subheadline)
                .foregroundStyle(Color.babyTextLight)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(BabyGradient.welcome)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.babyPink.opacity(0.3), lineWidth: 2)
        )
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
        ], spacing: 12) {
            StatCardView(icon: "🍼", value: "\(todayMilk.count)", label: "今日喝奶次數", accentColor: .babyBlue)
            StatCardView(icon: "🥣", value: "\(todayFood.count)", label: "今日副食品", accentColor: .babyMint)
            StatCardView(icon: "📊", value: "\(allMilk.todayTotalML) ml", label: "今日奶量", accentColor: .babyPeach)
            StatCardView(icon: "⏰", value: lastFeedTime(milk: allMilk, food: allFood), label: "上次餵食", accentColor: .babyLavender)
        }
    }

    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📋 今日時間軸")
                .font(.headline)

            if timeline.isEmpty {
                VStack(spacing: 12) {
                    Text("📝").font(.system(size: 48)).opacity(0.5)
                    Text("還沒有紀錄喔，快來記錄寶寶的第一餐吧！")
                        .font(.subheadline)
                        .foregroundStyle(Color.babyTextLight)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(timeline) { entry in
                        TimelineItemView(entry: entry)
                        if entry.id != timeline.last?.id {
                            Divider().background(Color.babyPinkLight)
                        }
                    }
                }
            }
        }
        .babyCard()
    }

    private var dailyTipCard: some View {
        let tip = BabyTip.dailyTip
        return VStack(spacing: 8) {
            Text("💖").font(.system(size: 32))
            Text("\(tip.emoji) \(tip.title)")
                .font(.subheadline).fontWeight(.semibold)
            Text(tip.text)
                .font(.caption)
                .foregroundStyle(Color.babyText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(BabyGradient.tipHighlight)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.babyPeach, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
        )
    }
}
