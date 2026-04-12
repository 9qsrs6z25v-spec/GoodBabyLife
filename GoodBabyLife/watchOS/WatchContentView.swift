import SwiftUI
import SwiftData

struct WatchContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink { WatchDashboardView() } label: {
                        Label { Text("今日總覽") } icon: { Text("🏠") }
                    }
                }
                Section("快速記錄") {
                    NavigationLink { WatchMilkView() } label: {
                        Label { Text("記錄喝奶") } icon: { Text("🍼") }
                    }
                    NavigationLink { WatchFoodView() } label: {
                        Label { Text("記錄副食品") } icon: { Text("🥣") }
                    }
                }
                Section("今日小建議") {
                    let tip = BabyTip.dailyTip
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(tip.emoji) \(tip.title)").font(.caption).fontWeight(.bold)
                        Text(tip.text).font(.caption2).foregroundStyle(.secondary).lineLimit(3)
                    }.padding(.vertical, 4)
                }
            }
            .navigationTitle("👶 Baby")
        }
    }
}

struct WatchDashboardView: View {
    @Query(sort: \MilkRecord.date, order: .reverse) private var allMilk: [MilkRecord]
    @Query(sort: \FoodRecord.date, order: .reverse) private var allFood: [FoodRecord]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("🍼 喝奶").font(.caption2)
                        Text("\(allMilk.todayCount) 次").font(.title3).fontWeight(.bold)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("總量").font(.caption2)
                        Text("\(allMilk.todayTotalML) ml").font(.title3).fontWeight(.bold).foregroundStyle(Color.babyBlue)
                    }
                }
                .padding(12).background(Color.babyBlueLight.opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 12))

                HStack {
                    VStack(alignment: .leading) {
                        Text("🥣 副食品").font(.caption2)
                        Text("\(allFood.todayCount) 次").font(.title3).fontWeight(.bold)
                    }
                    Spacer()
                }
                .padding(12).background(Color.babyMintLight.opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 12))

                HStack {
                    Text("⏰ 上次餵食").font(.caption2)
                    Spacer()
                    Text(lastFeedTime(milk: allMilk, food: allFood)).font(.headline).fontWeight(.bold).foregroundStyle(Color.babyPinkDark)
                }
                .padding(12).background(Color.babyPinkLight.opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 12))

                let timeline = buildTimeline(milk: allMilk, food: allFood)
                if !timeline.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("最近紀錄").font(.caption).fontWeight(.semibold)
                        ForEach(timeline.prefix(3)) { entry in
                            HStack(spacing: 6) {
                                Text(entry.emoji).font(.caption)
                                Text(entry.title).font(.caption2).lineLimit(1)
                                Spacer()
                                Text(entry.time).font(.caption2).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("📊 今日")
    }
}
