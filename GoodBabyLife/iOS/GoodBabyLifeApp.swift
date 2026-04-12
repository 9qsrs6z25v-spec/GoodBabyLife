import SwiftUI

@main
struct GoodBabyLifeApp: App {
    let container = BabyDataContainer.create()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
