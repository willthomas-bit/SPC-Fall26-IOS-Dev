import SwiftUI

@main
struct HarborLogApp: App {
    @StateObject private var store = OutingStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
