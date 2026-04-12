import SwiftUI
import SwiftData

struct WatchMilkView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedType: MilkType = .formula
    @State private var amount: Int = 120
    @State private var saved = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("奶的種類").font(.caption2).foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    ForEach(MilkType.allCases) { type in
                        Button { selectedType = type } label: {
                            VStack(spacing: 2) {
                                Text(type.emoji).font(.system(size: 20))
                                Text(type.label).font(.system(size: 8))
                            }
                            .frame(maxWidth: .infinity).padding(.vertical, 6)
                            .background(selectedType == type ? Color.babyPinkLight : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }.buttonStyle(.plain)
                    }
                }

                VStack(spacing: 4) {
                    Text("奶量").font(.caption2).foregroundStyle(.secondary)
                    HStack {
                        Button { if amount > 10 { amount -= 10 } } label: {
                            Text("−").font(.headline).frame(width: 36, height: 36).background(Color.babyPinkLight).clipShape(Circle())
                        }.buttonStyle(.plain)
                        Text("\(amount) ml").font(.title3).fontWeight(.bold).frame(maxWidth: .infinity)
                        Button { if amount < 500 { amount += 10 } } label: {
                            Text("+").font(.headline).frame(width: 36, height: 36).background(Color.babyPinkLight).clipShape(Circle())
                        }.buttonStyle(.plain)
                    }
                }

                Button {
                    let record = MilkRecord(date: Date(), type: selectedType, amountML: amount)
                    modelContext.insert(record)
                    saved = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { saved = false }
                } label: {
                    HStack { Text("🍼"); Text("儲存").fontWeight(.semibold) }.frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent).tint(Color.babyBlue)

                if saved {
                    Text("✅ 已儲存！").font(.caption).foregroundStyle(.green).transition(.opacity)
                }
            }
        }
        .navigationTitle("🍼 喝奶")
    }
}
