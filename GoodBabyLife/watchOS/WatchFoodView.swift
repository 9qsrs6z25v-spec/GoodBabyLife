import SwiftUI

struct WatchFoodView: View {
    @Environment(DataStore.self) private var store
    @State private var selectedType: FoodType = .riceCereal
    @State private var amount: Int = 3
    @State private var selectedReaction: BabyReaction = .like
    @State private var saved = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Food Type
                Text("食物種類")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 4),
                    GridItem(.flexible(), spacing: 4),
                    GridItem(.flexible(), spacing: 4),
                ], spacing: 4) {
                    ForEach(FoodType.allCases) { type in
                        Button {
                            selectedType = type
                        } label: {
                            VStack(spacing: 1) {
                                Text(type.emoji)
                                    .font(.system(size: 18))
                                Text(type.label)
                                    .font(.system(size: 7))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(selectedType == type ? Color.babyMintLight : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Amount
                VStack(spacing: 4) {
                    Text("份量")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    HStack {
                        Button {
                            if amount > 1 { amount -= 1 }
                        } label: {
                            Text("−")
                                .font(.headline)
                                .frame(width: 36, height: 36)
                                .background(Color.babyMintLight)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)

                        Text("\(amount) 匙")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)

                        Button {
                            if amount < 50 { amount += 1 }
                        } label: {
                            Text("+")
                                .font(.headline)
                                .frame(width: 36, height: 36)
                                .background(Color.babyMintLight)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Reaction
                Text("寶寶反應")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                HStack(spacing: 4) {
                    ForEach(BabyReaction.allCases) { reaction in
                        Button {
                            selectedReaction = reaction
                        } label: {
                            Text(reaction.emoji)
                                .font(.system(size: 18))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(selectedReaction == reaction ? Color.babyPinkLight : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Save
                Button {
                    let record = FoodRecord(
                        date: Date(),
                        type: selectedType,
                        name: selectedType.label,
                        amountSpoons: amount,
                        reaction: selectedReaction
                    )
                    store.addFood(record)
                    saved = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        saved = false
                    }
                } label: {
                    HStack {
                        Text("🥣")
                        Text("儲存")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.babyMint)

                if saved {
                    Text("✅ 已儲存！")
                        .font(.caption)
                        .foregroundStyle(.green)
                        .transition(.opacity)
                }
            }
        }
        .navigationTitle("🥣 副食品")
    }
}

#Preview {
    WatchFoodView()
        .environment(DataStore())
}
