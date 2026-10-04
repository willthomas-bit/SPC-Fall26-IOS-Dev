import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            OutingListView()
                .tabItem {
                    Label("Log", systemImage: "list.bullet")
                }
            ReportsView()
                .tabItem {
                    Label("Reports", systemImage: "chart.bar")
                }
            WeatherView()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                }
        }
    }
}
