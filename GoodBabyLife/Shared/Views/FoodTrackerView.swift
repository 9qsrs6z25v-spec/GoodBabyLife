import SwiftUI
import SwiftData

struct FoodTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FoodRecord.date, order: .reverse) private var allFood: [FoodRecord]

    @State private var selectedType: FoodType = .riceCereal
    @State private var foodName: String = ""
    @State private var amount: Int = 3
    @State private var selectedReaction: BabyReaction = .like
    @State private var note: String = ""
    @State private var selectedTime = Date()
    @State private var showSavedToast = false

    private var todayRecords: [FoodRecord] { allFood.today }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                formSection
                historySection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color.babyBg)
        .navigationTitle("🥣 副食品紀錄")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .overlay(alignment: .top) {
            if showSavedToast {
                toastView.transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("🥣 記錄副食品").font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                Text("食物種類").font(.subheadline).fontWeight(.semibold)
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                    ForEach(FoodType.allCases) { type in
                        Button {
                            withAnimation(.spring(duration: 0.3)) { selectedType = type }
                        } label: {
                            VStack(spacing: 4) {
                                Text(type.emoji).font(.system(size: 28))
                                Text(type.label).font(.caption2)
                            }
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(selectedType == type ? Color.babyMintLight : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(selectedType == type ? Color.babyMint : Color.babyMintLight, lineWidth: 2))
                        }
                        .buttonStyle(.plain)
                        .scaleEffect(selectedType == type ? 1.02 : 1.0)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("食物名稱").font(.subheadline).fontWeight(.semibold)
                TextField("例如：南瓜泥、香蕉泥...", text: $foodName)
                    #if !os(watchOS)
                    .textFieldStyle(.roundedBorder)
                    #endif
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("份量 (湯匙)").font(.subheadline).fontWeight(.semibold)
                stepperRow(value: $amount, range: 0...50, step: 1, unit: "湯匙")
            }

            DatePicker("時間", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .font(.subheadline).fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 8) {
                Text("寶寶反應").font(.subheadline).fontWeight(.semibold)
                HStack(spacing: 6) {
                    ForEach(BabyReaction.allCases) { reaction in
                        Button {
                            withAnimation(.spring(duration: 0.3)) { selectedReaction = reaction }
                        } label: {
                            VStack(spacing: 2) {
                                Text(reaction.emoji).font(.system(size: 22))
                                Text(reaction.label).font(.system(size: 9))
                            }
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(selectedReaction == reaction ? Color.babyPinkLight : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(selectedReaction == reaction ? Color.babyPinkDark : Color.babyLavender, lineWidth: 2))
                        }
                        .buttonStyle(.plain)
                        .scaleEffect(selectedReaction == reaction ? 1.05 : 1.0)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("備註").font(.subheadline).fontWeight(.semibold)
                TextField("過敏反應、特別狀況...", text: $note)
                    #if !os(watchOS)
                    .textFieldStyle(.roundedBorder)
                    #endif
            }

            Button(action: saveFoodRecord) {
                HStack { Text("🥣"); Text("儲存紀錄").fontWeight(.semibold) }
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(BabyGradient.foodButton).foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .babyCard()
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📜 今日副食品紀錄").font(.headline)

            if todayRecords.isEmpty {
                VStack(spacing: 12) {
                    Text("🥣").font(.system(size: 48)).opacity(0.5)
                    Text("今天還沒有副食品紀錄喔！").font(.subheadline).foregroundStyle(Color.babyTextLight)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 32)
            } else {
                ForEach(todayRecords) { record in
                    HStack(spacing: 12) {
                        Text(record.type.emoji).font(.system(size: 28))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(record.displayName) \(record.amountSpoons)湯匙").font(.subheadline).fontWeight(.semibold)
                            Text("\(record.reaction.emoji) \(record.reaction.label)\(record.note.isEmpty ? "" : " · \(record.note)")").font(.caption).foregroundStyle(Color.babyTextLight)
                        }
                        Spacer()
                        Text(record.timeString).font(.caption).fontWeight(.semibold).foregroundStyle(Color.babyPinkDark)
                        Button { withAnimation { modelContext.delete(record) } } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(Color.babyTextLight.opacity(0.4))
                        }.buttonStyle(.plain)
                    }
                    .padding(12).background(Color.babyMintLight).clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .babyCard()
    }

    private func saveFoodRecord() {
        let record = FoodRecord(date: selectedTime, type: selectedType, name: foodName, amountSpoons: amount, reaction: selectedReaction, note: note)
        modelContext.insert(record)
        foodName = ""
        note = ""
        selectedTime = Date()
        withAnimation(.spring(duration: 0.4)) { showSavedToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { withAnimation { showSavedToast = false } }
    }

    private func stepperRow(value: Binding<Int>, range: ClosedRange<Int>, step: Int, unit: String) -> some View {
        HStack {
            Button { if value.wrappedValue - step >= range.lowerBound { value.wrappedValue -= step } } label: {
                Text("−").font(.title2).fontWeight(.bold).frame(width: 44, height: 44).background(Color.babyMintLight).foregroundStyle(Color.babyMint).clipShape(RoundedRectangle(cornerRadius: 10))
            }.buttonStyle(.plain)
            Spacer()
            Text("\(value.wrappedValue) \(unit)").font(.title2).fontWeight(.bold).foregroundStyle(Color.babyText)
            Spacer()
            Button { if value.wrappedValue + step <= range.upperBound { value.wrappedValue += step } } label: {
                Text("+").font(.title2).fontWeight(.bold).frame(width: 44, height: 44).background(Color.babyMintLight).foregroundStyle(Color.babyMint).clipShape(RoundedRectangle(cornerRadius: 10))
            }.buttonStyle(.plain)
        }
        .padding(8).background(Color.babyBg).clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var toastView: some View {
        HStack(spacing: 8) { Text("✅"); Text("副食品紀錄已儲存！").font(.subheadline).fontWeight(.semibold) }
            .padding(.horizontal, 24).padding(.vertical, 12)
            .background(.white).clipShape(Capsule())
            .shadow(color: Color.babyMint.opacity(0.3), radius: 10, y: 4)
            .overlay(Capsule().stroke(Color.babyMint, lineWidth: 2))
            .padding(.top, 8)
    }
}
