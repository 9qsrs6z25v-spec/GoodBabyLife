import Foundation

enum MilkType: String, Codable, CaseIterable, Identifiable {
    case breast = "breast"
    case formula = "formula"
    case mixed = "mixed"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .breast: return "母乳"
        case .formula: return "配方奶"
        case .mixed: return "混合"
        }
    }

    var emoji: String {
        switch self {
        case .breast: return "🤱"
        case .formula: return "🍼"
        case .mixed: return "🥛"
        }
    }
}

struct MilkRecord: Identifiable, Codable {
    let id: UUID
    var date: Date
    var type: MilkType
    var amountML: Int
    var durationMinutes: Int
    var note: String

    init(id: UUID = UUID(), date: Date = Date(), type: MilkType = .formula, amountML: Int = 120, durationMinutes: Int = 15, note: String = "") {
        self.id = id
        self.date = date
        self.type = type
        self.amountML = amountML
        self.durationMinutes = durationMinutes
        self.note = note
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
