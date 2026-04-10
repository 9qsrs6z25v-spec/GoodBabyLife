import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        #if os(tvOS)
        TVContentView()
        #elseif os(watchOS)
        WatchContentView()
        #else
        iOSContentView(selectedTab: $selectedTab)
        #endif
    }
}

// MARK: - iOS & iPadOS

struct iOSContentView: View {
    @Binding var selectedTab: Int

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("首頁", systemImage: "house.fill")
            }
            .tag(0)

            NavigationStack {
                MilkTrackerView()
            }
            .tabItem {
                Label("喝奶", systemImage: "cup.and.saucer.fill")
            }
            .tag(1)

            NavigationStack {
                FoodTrackerView()
            }
            .tabItem {
                Label("副食品", systemImage: "fork.knife")
            }
            .tag(2)

            NavigationStack {
                TipsView()
            }
            .tabItem {
                Label("小建議", systemImage: "lightbulb.fill")
            }
            .tag(3)
        }
        .tint(Color.babyPinkDark)
    }
}

#Preview {
    ContentView()
        .environment(DataStore())
}
