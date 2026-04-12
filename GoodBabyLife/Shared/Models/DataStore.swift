import Foundation
import SwiftData

// MARK: - Shared ModelContainer with CloudKit

enum BabyDataContainer {
    static func create() -> ModelContainer {
        let schema = Schema([MilkRecord.self, FoodRecord.self])
        let config = ModelConfiguration(
            schema: schema,
            cloudKitDatabase: .automatic
        )
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}

// MARK: - Timeline Entry

struct TimelineEntry: Identifiable {
    let id: UUID
    let date: Date
    let emoji: String
    let title: String
    let detail: String
    let time: String
    let isMilk: Bool
}

// MARK: - Today Helpers

extension Array where Element == MilkRecord {
    var today: [MilkRecord] {
        let start = Calendar.current.startOfDay(for: Date())
        return filter { $0.date >= start }.sorted { $0.date > $1.date }
    }

    var todayCount: Int { today.count }

    var todayTotalML: Int { today.reduce(0) { $0 + $1.amountML } }
}

extension Array where Element == FoodRecord {
    var today: [FoodRecord] {
        let start = Calendar.current.startOfDay(for: Date())
        return filter { $0.date >= start }.sorted { $0.date > $1.date }
    }

    var todayCount: Int { today.count }
}

// MARK: - Stats Helpers

func lastFeedTime(milk: [MilkRecord], food: [FoodRecord]) -> String {
    let allDates = milk.today.map(\.date) + food.today.map(\.date)
    guard let latest = allDates.max() else { return "--:--" }
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: latest)
}

func buildTimeline(milk: [MilkRecord], food: [FoodRecord]) -> [TimelineEntry] {
    var entries: [TimelineEntry] = []

    for m in milk.today {
        entries.append(TimelineEntry(
            id: m.id,
            date: m.date,
            emoji: m.type.emoji,
            title: "\(m.type.label) \(m.amountML)ml",
            detail: "\(m.durationMinutes)分鐘\(m.note.isEmpty ? "" : " · \(m.note)")",
            time: m.timeString,
            isMilk: true
        ))
    }

    for f in food.today {
        entries.append(TimelineEntry(
            id: f.id,
            date: f.date,
            emoji: f.type.emoji,
            title: "\(f.displayName) \(f.amountSpoons)湯匙",
            detail: "\(f.reaction.emoji) \(f.reaction.label)\(f.note.isEmpty ? "" : " · \(f.note)")",
            time: f.timeString,
            isMilk: false
        ))
    }

    return entries.sorted { $0.date > $1.date }
}

func welcomeMessage(milkCount: Int, foodCount: Int) -> String {
    let total = milkCount + foodCount
    switch total {
    case 0: return "記錄寶寶美好的一天吧！"
    case 1...2: return "寶寶今天開始吃東西囉，繼續加油！"
    case 3...5: return "寶寶今天吃得不錯呢，真棒！"
    case 6...8: return "寶寶今天好認真吃飯，超乖的！"
    default: return "哇，寶寶今天食慾好好，是個小吃貨！"
    }
}
