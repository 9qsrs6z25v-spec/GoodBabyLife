import SwiftUI

@main
struct GoodBabyLifeWatchApp: App {
    @State private var store = DataStore()

    var body: some Scene {
        WindowGroup {
            WatchContentView()
                .environment(store)
        }
    }
}
