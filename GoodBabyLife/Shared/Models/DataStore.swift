import Foundation
import SwiftUI

@Observable
final class DataStore {
    var milkRecords: [MilkRecord] = []
    var foodRecords: [FoodRecord] = []

    private let milkKey = "goodbaby_milk"
    private let foodKey = "goodbaby_food"

    init() {
        load()
    }

    // MARK: - Persistence

    private var milkURL: URL {
        fileURL(for: milkKey)
    }

    private var foodURL: URL {
        fileURL(for: foodKey)
    }

    private func fileURL(for name: String) -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("\(name).json")
    }

    func load() {
        milkRecords = loadFromFile(milkURL) ?? []
        foodRecords = loadFromFile(foodURL) ?? []
    }

    func save() {
        saveToFile(milkRecords, url: milkURL)
        saveToFile(foodRecords, url: foodURL)
    }

    private func loadFromFile<T: Decodable>(_ url: URL) -> T? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    private func saveToFile<T: Encodable>(_ value: T, url: URL) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        try? data.write(to: url, options: .atomic)
    }

    // MARK: - Milk

    func addMilk(_ record: MilkRecord) {
        milkRecords.insert(record, at: 0)
        save()
    }

    func deleteMilk(at offsets: IndexSet) {
        let today = todayMilkRecords
        let idsToRemove = offsets.map { today[$0].id }
        milkRecords.removeAll { idsToRemove.contains($0.id) }
        save()
    }

    func deleteMilk(id: UUID) {
        milkRecords.removeAll { $0.id == id }
        save()
    }

    // MARK: - Food

    func addFood(_ record: FoodRecord) {
        foodRecords.insert(record, at: 0)
        save()
    }

    func deleteFood(at offsets: IndexSet) {
        let today = todayFoodRecords
        let idsToRemove = offsets.map { today[$0].id }
        foodRecords.removeAll { idsToRemove.contains($0.id) }
        save()
    }

    func deleteFood(id: UUID) {
        foodRecords.removeAll { $0.id == id }
        save()
    }

    // MARK: - Today's Data

    private var todayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    var todayMilkRecords: [MilkRecord] {
        milkRecords.filter { $0.dateString == todayString }
    }

    var todayFoodRecords: [FoodRecord] {
        foodRecords.filter { $0.dateString == todayString }
    }

    var todayMilkCount: Int { todayMilkRecords.count }
    var todayFoodCount: Int { todayFoodRecords.count }

    var todayTotalML: Int {
        todayMilkRecords.reduce(0) { $0 + $1.amountML }
    }

    var lastFeedTime: String {
        let allDates: [Date] = todayMilkRecords.map(\.date) + todayFoodRecords.map(\.date)
        guard let latest = allDates.max() else { return "--:--" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: latest)
    }

    // MARK: - Timeline

    struct TimelineEntry: Identifiable {
        let id: UUID
        let date: Date
        let emoji: String
        let title: String
        let detail: String
        let time: String
        let isMilk: Bool
    }

    var todayTimeline: [TimelineEntry] {
        var entries: [TimelineEntry] = []

        for m in todayMilkRecords {
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

        for f in todayFoodRecords {
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

    var welcomeMessage: String {
        let total = todayMilkCount + todayFoodCount
        switch total {
        case 0: return "記錄寶寶美好的一天吧！"
        case 1...2: return "寶寶今天開始吃東西囉，繼續加油！"
        case 3...5: return "寶寶今天吃得不錯呢，真棒！"
        case 6...8: return "寶寶今天好認真吃飯，超乖的！"
        default: return "哇，寶寶今天食慾好好，是個小吃貨！"
        }
    }
}
