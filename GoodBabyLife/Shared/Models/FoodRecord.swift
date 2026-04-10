import Foundation

enum FoodType: String, Codable, CaseIterable, Identifiable {
    case riceCereal = "rice_cereal"
    case veggie = "veggie"
    case fruit = "fruit"
    case protein = "protein"
    case porridge = "porridge"
    case other = "other"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .riceCereal: return "米糊"
        case .veggie: return "蔬菜泥"
        case .fruit: return "水果泥"
        case .protein: return "蛋白質"
        case .porridge: return "粥品"
        case .other: return "其他"
        }
    }

    var emoji: String {
        switch self {
        case .riceCereal: return "🍚"
        case .veggie: return "🥦"
        case .fruit: return "🍎"
        case .protein: return "🍗"
        case .porridge: return "🥘"
        case .other: return "🍽️"
        }
    }
}

enum BabyReaction: String, Codable, CaseIterable, Identifiable {
    case love = "love"
    case like = "like"
    case ok = "ok"
    case dislike = "dislike"
    case refuse = "refuse"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .love: return "超愛"
        case .like: return "喜歡"
        case .ok: return "普通"
        case .dislike: return "不愛"
        case .refuse: return "拒吃"
        }
    }

    var emoji: String {
        switch self {
        case .love: return "😍"
        case .like: return "😊"
        case .ok: return "😐"
        case .dislike: return "😣"
        case .refuse: return "🙅"
        }
    }
}

struct FoodRecord: Identifiable, Codable {
    let id: UUID
    var date: Date
    var type: FoodType
    var name: String
    var amountSpoons: Int
    var reaction: BabyReaction
    var note: String

    init(id: UUID = UUID(), date: Date = Date(), type: FoodType = .riceCereal, name: String = "", amountSpoons: Int = 3, reaction: BabyReaction = .like, note: String = "") {
        self.id = id
        self.date = date
        self.type = type
        self.name = name
        self.amountSpoons = amountSpoons
        self.reaction = reaction
        self.note = note
    }

    var displayName: String {
        name.isEmpty ? type.label : name
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
