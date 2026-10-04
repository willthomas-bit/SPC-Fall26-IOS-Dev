import SwiftUI
import Charts

struct ReportsView: View {
    @EnvironmentObject private var store: OutingStore
    @State private var showBars = true

    var body: some View {
        NavigationStack {
            List {
                Section {
                    LabeledContent("Outings", value: "\(store.outings.count)")
                    LabeledContent("Average rating", value: String(format: "%.1f", store.averageRating))
                }
                Section("By place") {
                    if store.outings.isEmpty {
                        Text("Add an outing to see a chart.")
                            .foregroundStyle(.secondary)
                    } else if showBars {
                        Chart(store.countsByPlace(), id: \.place) { item in
                            BarMark(
                                x: .value("Place", item.place),
                                y: .value("Count", item.count)
                            )
                            .foregroundStyle(by: .value("Place", item.place))
                        }
                        .frame(height: 220)
                    } else {
                        Chart(store.outings.sorted { $0.date < $1.date }) { outing in
                            LineMark(
                                x: .value("Date", outing.date),
                                y: .value("Rating", outing.rating)
                            )
                            .symbol(.circle)
                            .interpolationMethod(.catmullRom)
                        }
                        .frame(height: 220)
                    }
                    Toggle("Bar chart", isOn: $showBars)
                }
            }
            .navigationTitle("Reports")
        }
    }
}
