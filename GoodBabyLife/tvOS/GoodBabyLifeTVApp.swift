import SwiftUI

@main
struct GoodBabyLifeTVApp: App {
    let container = BabyDataContainer.create()

    var body: some Scene {
        WindowGroup {
            TVContentView()
        }
        .modelContainer(container)
    }
}
