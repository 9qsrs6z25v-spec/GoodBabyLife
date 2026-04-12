import SwiftUI
import SwiftData

struct TVContentView: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink { TVDashboardView() } label: {
                    Label { Text("今日總覽").font(.title3) } icon: { Text("🏠").font(.title2) }
                }
                NavigationLink { TVTipsView() } label: {
                    Label { Text("可愛小建議").font(.title3) } icon: { Text("💡").font(.title2) }
                }
                NavigationLink { TVTimelineView() } label: {
                    Label { Text("今日時間軸").font(.title3) } icon: { Text("📋").font(.title2) }
                }
            }
            .navigationTitle("👶 Good Baby Life")
        } detail: {
            TVDashboardView()
        }
    }
}

struct TVDashboardView: View {
    @Query(sort: \MilkRecord.date, order: .reverse) private var allMilk: [MilkRecord]
    @Query(sort: \FoodRecord.date, order: .reverse) private var allFood: [FoodRecord]

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                VStack(spacing: 12) {
                    Text("🌟").font(.system(size: 80)).pulseEffect()
                    Text("今日寶寶日誌").font(.largeTitle).fontWeight(.bold)
                    Text(welcomeMessage(milkCount: allMilk.todayCount, foodCount: allFood.todayCount))
                        .font(.title3).foregroundStyle(.secondary)
                }.padding(40)

                HStack(spacing: 30) {
                    TVStatCard(icon: "🍼", value: "\(allMilk.todayCount)", label: "喝奶次數", bg: Color.babyBlueLight)
                    TVStatCard(icon: "🥣", value: "\(allFood.todayCount)", label: "副食品", bg: Color.babyMintLight)
                    TVStatCard(icon: "📊", value: "\(allMilk.todayTotalML) ml", label: "今日奶量", bg: Color.babyPeachLight)
                    TVStatCard(icon: "⏰", value: lastFeedTime(milk: allMilk, food: allFood), label: "上次餵食", bg: Color.babyLavenderLight)
                }.padding(.horizontal, 40)

                let tip = BabyTip.dailyTip
                VStack(spacing: 16) {
                    Text("💖 今日小建議").font(.title2).fontWeight(.bold)
                    HStack(spacing: 20) {
                        Text(tip.emoji).font(.system(size: 60))
                        VStack(alignment: .leading, spacing: 8) {
                            Text(tip.title).font(.title3).fontWeight(.bold)
                            Text(tip.text).font(.body).foregroundStyle(.secondary).lineSpacing(6)
                        }
                    }
                }
                .padding(40).frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 24).fill(BabyGradient.tipHighlight))
                .padding(.horizontal, 40)
            }.padding(.bottom, 60)
        }
    }
}

struct TVStatCard: View {
    let icon: String; let value: String; let label: String; let bg: Color
    var body: some View {
        VStack(spacing: 12) {
            Text(icon).font(.system(size: 48))
            Text(value).font(.title).fontWeight(.bold)
            Text(label).font(.callout).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding(30).background(bg).clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct TVTimelineView: View {
    @Query(sort: \MilkRecord.date, order: .reverse) private var allMilk: [MilkRecord]
    @Query(sort: \FoodRecord.date, order: .reverse) private var allFood: [FoodRecord]

    var body: some View {
        let timeline = buildTimeline(milk: allMilk, food: allFood)
        ScrollView {
            VStack(spacing: 20) {
                Text("📋 今日時間軸").font(.largeTitle).fontWeight(.bold).padding(.top, 20)
                if timeline.isEmpty {
                    VStack(spacing: 20) {
                        Text("📝").font(.system(size: 80)).opacity(0.5)
                        Text("今天還沒有紀錄喔！").font(.title2).foregroundStyle(.secondary)
                    }.padding(.top, 60)
                } else {
                    ForEach(timeline) { entry in
                        HStack(spacing: 20) {
                            Text(entry.emoji).font(.system(size: 40))
                                .frame(width: 60, height: 60)
                                .background(entry.isMilk ? Color.babyBlueLight : Color.babyMintLight)
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.title).font(.title3).fontWeight(.semibold)
                                Text(entry.detail).font(.body).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(entry.time).font(.title3).fontWeight(.semibold).foregroundStyle(Color.babyPinkDark)
                        }
                        .padding(20).background(.white).clipShape(RoundedRectangle(cornerRadius: 16)).padding(.horizontal, 40)
                    }
                }
            }.padding(.bottom, 60)
        }
    }
}
