import Foundation

enum TipCategory: String, Codable {
    case milk
    case food
    case sleep
    case general

    var label: String {
        switch self {
        case .milk: return "🍼 喝奶"
        case .food: return "🥣 副食品"
        case .sleep: return "😴 睡眠"
        case .general: return "💫 一般"
        }
    }
}

struct BabyTip: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let text: String
    let category: TipCategory

    static let allTips: [BabyTip] = [
        BabyTip(
            emoji: "🍼",
            title: "喝奶小知識",
            text: "新生兒每天大約需要喝 8-12 次奶，每次約 60-120ml。隨著寶寶長大，每次奶量會增加，但次數會減少喔！",
            category: .milk
        ),
        BabyTip(
            emoji: "🥣",
            title: "副食品開始時機",
            text: "一般建議寶寶在 4-6 個月大時開始嘗試副食品。觀察寶寶是否能穩定坐著、對食物表現出興趣，就可以慢慢開始囉！",
            category: .food
        ),
        BabyTip(
            emoji: "🌡️",
            title: "奶的溫度很重要",
            text: "配方奶的最佳溫度約 37-40°C，接近體溫最舒適。可以滴幾滴在手腕內側測試，感覺溫溫的就剛好！",
            category: .milk
        ),
        BabyTip(
            emoji: "🥕",
            title: "副食品循序漸進",
            text: "每次只嘗試一種新食物，觀察 3-5 天確認沒有過敏反應再換下一種。從米糊開始，再到蔬菜泥、水果泥！",
            category: .food
        ),
        BabyTip(
            emoji: "💤",
            title: "餵奶後拍嗝",
            text: "餵完奶後記得幫寶寶拍嗝喔！將寶寶直立靠在肩膀上，輕輕拍背部，可以減少脹氣和溢奶的情況。",
            category: .milk
        ),
        BabyTip(
            emoji: "🎨",
            title: "讓吃飯變有趣",
            text: "用色彩繽紛的食物吸引寶寶注意力！南瓜是橘色、菠菜是綠色、地瓜是黃色，讓每一餐都像在畫畫一樣有趣。",
            category: .food
        ),
        BabyTip(
            emoji: "😴",
            title: "睡前不要餵太飽",
            text: "睡前適量餵奶就好，太飽反而容易溢奶或不舒服。讓寶寶在舒適的狀態下入睡，睡眠品質會更好喔！",
            category: .sleep
        ),
        BabyTip(
            emoji: "💧",
            title: "開始喝水的時機",
            text: "6 個月以下的寶寶通常不需要額外喝水，母乳和配方奶已經含有足夠水分。開始吃副食品後可以少量給水。",
            category: .general
        ),
        BabyTip(
            emoji: "🦷",
            title: "長牙期的飲食",
            text: "寶寶長牙時可能會不太想吃東西，這是正常的！可以給冰涼的水果泥或咬咬樂來舒緩牙齦不適。",
            category: .food
        ),
        BabyTip(
            emoji: "📝",
            title: "記錄過敏反應",
            text: "嘗試新食物時，注意觀察寶寶是否有紅疹、腹瀉、嘔吐等過敏症狀。詳細記錄可以幫助醫生判斷過敏原喔！",
            category: .food
        ),
        BabyTip(
            emoji: "🤱",
            title: "母乳保存小技巧",
            text: "擠出的母乳在室溫下可保存 4 小時，冷藏可保存 4 天，冷凍可保存 6 個月。記得標註日期，先進先出！",
            category: .milk
        ),
        BabyTip(
            emoji: "🌟",
            title: "每個寶寶都不同",
            text: "不用和別的寶寶比較，每個孩子都有自己的成長節奏。有些寶寶愛吃，有些比較挑食，都是正常的喔！放輕鬆享受親子時光吧！",
            category: .general
        ),
        BabyTip(
            emoji: "🥄",
            title: "湯匙餵食技巧",
            text: "用小湯匙的前端輕輕放在寶寶下唇上，等寶寶自己張嘴再送入。不要硬塞喔，讓寶寶學習主動進食！",
            category: .food
        ),
        BabyTip(
            emoji: "⏰",
            title: "規律的餵食時間",
            text: "盡量建立規律的餵食時間表，寶寶的生理時鐘會慢慢調整，也更容易預測什麼時候會餓。但也不用太死板，看寶寶的需求調整！",
            category: .general
        ),
        BabyTip(
            emoji: "🧡",
            title: "爸媽也要照顧自己",
            text: "帶寶寶雖然辛苦，但記得也要好好休息、吃飯。只有爸媽身體健康、心情好，才能給寶寶最好的照顧喔！你們做得很棒！",
            category: .general
        ),
    ]

    static var dailyTip: BabyTip {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return allTips[dayOfYear % allTips.count]
    }
}
