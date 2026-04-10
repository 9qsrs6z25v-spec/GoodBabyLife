import SwiftUI

struct MilkTrackerView: View {
    @Environment(DataStore.self) private var store
    @State private var selectedType: MilkType = .formula
    @State private var amount: Int = 120
    @State private var duration: Int = 15
    @State private var note: String = ""
    @State private var selectedTime = Date()
    @State private var showSavedToast = false

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
        .navigationTitle("🍼 喝奶紀錄")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .overlay(alignment: .top) {
            if showSavedToast {
                toastView
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    // MARK: - Form

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("🍼 記錄喝奶")
                .font(.headline)

            // Milk Type
            VStack(alignment: .leading, spacing: 8) {
                Text("奶的種類")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                HStack(spacing: 8) {
                    ForEach(MilkType.allCases) { type in
                        milkTypeButton(type)
                    }
                }
            }

            // Amount
            VStack(alignment: .leading, spacing: 8) {
                Text("奶量 (ml)")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                stepperRow(value: $amount, range: 0...500, step: 10, unit: "ml")
            }

            // Duration
            VStack(alignment: .leading, spacing: 8) {
                Text("喝奶時長 (分鐘)")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                stepperRow(value: $duration, range: 0...120, step: 5, unit: "分鐘")
            }

            // Time
            DatePicker("時間", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .font(.subheadline)
                .fontWeight(.semibold)

            // Note
            VStack(alignment: .leading, spacing: 8) {
                Text("備註")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                TextField("寶寶喝得很開心 🥰", text: $note)
                    .textFieldStyle(.roundedBorder)
            }

            // Submit
            Button(action: saveMilkRecord) {
                HStack {
                    Text("🍼")
                    Text("儲存紀錄")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(BabyGradient.milkButton)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .babyCard()
    }

    private func milkTypeButton(_ type: MilkType) -> some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                selectedType = type
            }
        } label: {
            VStack(spacing: 4) {
                Text(type.emoji)
                    .font(.system(size: 24))
                Text(type.label)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(selectedType == type ? Color.babyPinkLight : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedType == type ? Color.babyPinkDark : Color.babyPinkLight, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(selectedType == type ? 1.02 : 1.0)
    }

    private func stepperRow(value: Binding<Int>, range: ClosedRange<Int>, step: Int, unit: String) -> some View {
        HStack {
            Button {
                if value.wrappedValue - step >= range.lowerBound {
                    value.wrappedValue -= step
                }
            } label: {
                Text("−")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 44, height: 44)
                    .background(Color.babyPinkLight)
                    .foregroundStyle(Color.babyPinkDark)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)

            Spacer()

            Text("\(value.wrappedValue) \(unit)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.babyText)

            Spacer()

            Button {
                if value.wrappedValue + step <= range.upperBound {
                    value.wrappedValue += step
                }
            } label: {
                Text("+")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 44, height: 44)
                    .background(Color.babyPinkLight)
                    .foregroundStyle(Color.babyPinkDark)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
        .padding(8)
        .background(Color.babyBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - History

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📜 今日喝奶紀錄")
                .font(.headline)

            if store.todayMilkRecords.isEmpty {
                VStack(spacing: 12) {
                    Text("🍼")
                        .font(.system(size: 48))
                        .opacity(0.5)
                    Text("今天還沒有喝奶紀錄喔！")
                        .font(.subheadline)
                        .foregroundStyle(Color.babyTextLight)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                ForEach(store.todayMilkRecords) { record in
                    milkHistoryRow(record)
                }
            }
        }
        .babyCard()
    }

    private func milkHistoryRow(_ record: MilkRecord) -> some View {
        HStack(spacing: 12) {
            Text(record.type.emoji)
                .font(.system(size: 28))

            VStack(alignment: .leading, spacing: 2) {
                Text("\(record.type.label) \(record.amountML)ml")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("\(record.durationMinutes)分鐘\(record.note.isEmpty ? "" : " · \(record.note)")")
                    .font(.caption)
                    .foregroundStyle(Color.babyTextLight)
            }

            Spacer()

            Text(record.timeString)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.babyPinkDark)

            Button {
                withAnimation {
                    store.deleteMilk(id: record.id)
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(Color.babyTextLight.opacity(0.4))
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(Color.babyBlueLight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Actions

    private func saveMilkRecord() {
        let record = MilkRecord(
            date: selectedTime,
            type: selectedType,
            amountML: amount,
            durationMinutes: duration,
            note: note
        )
        store.addMilk(record)
        note = ""
        selectedTime = Date()

        withAnimation(.spring(duration: 0.4)) {
            showSavedToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showSavedToast = false }
        }
    }

    // MARK: - Toast

    private var toastView: some View {
        HStack(spacing: 8) {
            Text("✅")
            Text("喝奶紀錄已儲存！")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.white)
        .clipShape(Capsule())
        .shadow(color: Color.babyMint.opacity(0.3), radius: 10, y: 4)
        .overlay(
            Capsule()
                .stroke(Color.babyMint, lineWidth: 2)
        )
        .padding(.top, 8)
    }
}

#Preview {
    NavigationStack {
        MilkTrackerView()
    }
    .environment(DataStore())
}
