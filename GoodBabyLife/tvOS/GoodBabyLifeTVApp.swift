import SwiftUI

@main
struct GoodBabyLifeTVApp: App {
    @State private var store = DataStore()

    var body: some Scene {
        WindowGroup {
            TVContentView()
                .environment(store)
        }
    }
}
