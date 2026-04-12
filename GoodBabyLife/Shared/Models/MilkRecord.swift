import Foundation
import SwiftData

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

@Model
final class MilkRecord {
    var id: UUID = UUID()
    var date: Date = Date()
    var type: MilkType = MilkType.formula
    var amountML: Int = 120
    var durationMinutes: Int = 15
    var note: String = ""

    init(date: Date = Date(), type: MilkType = .formula, amountML: Int = 120, durationMinutes: Int = 15, note: String = "") {
        self.id = UUID()
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
}
