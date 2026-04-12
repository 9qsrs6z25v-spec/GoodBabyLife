import SwiftUI

@main
struct GoodBabyLifeWatchApp: App {
    let container = BabyDataContainer.create()

    var body: some Scene {
        WindowGroup {
            WatchContentView()
        }
        .modelContainer(container)
    }
}
