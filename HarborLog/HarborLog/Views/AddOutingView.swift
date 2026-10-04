import SwiftUI

struct AddOutingView: View {
    @EnvironmentObject private var store: OutingStore
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var place = "St. Pete Pier"
    @State private var notes = ""
    @State private var rating = 3
    @State private var date = Date()
    @State private var weatherSummary = ""
    @State private var isLoadingWeather = false

    private let places = ["St. Pete Pier", "Vinoy Park", "Spa Beach", "Coffee Pot Bayou", "North Shore Park"]
    private let service = WeatherService()

    var body: some View {
        NavigationStack {
            Form {
                Section("Stop") {
                    TextField("Title", text: $title)
                    Picker("Place", selection: $place) {
                        ForEach(places, id: \.self) { name in
                            Text(name).tag(name)
                        }
                    }
                    DatePicker("When", selection: $date)
                }
                Section("Rating") {
                    RatingView(rating: $rating)
                    Text("Tap a wave. 1 is a short stop, 5 is worth going back.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Section("Notes") {
                    TextField("What was it like?", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                Section("Current harbor weather") {
                    if isLoadingWeather {
                        ProgressView("Fetching from Open-Meteo")
                    } else if weatherSummary.isEmpty {
                        Text("Weather was not attached.")
                            .foregroundStyle(.secondary)
                    } else {
                        Text(weatherSummary)
                    }
                    Button("Refresh weather") {
                        Task { await loadWeather() }
                    }
                }
            }
            .navigationTitle("New outing")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let outing = Outing(
                            title: title.trimmingCharacters(in: .whitespaces),
                            place: place,
                            notes: notes,
                            rating: rating,
                            date: date,
                            weatherSummary: weatherSummary
                        )
                        store.add(outing)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .task {
                await loadWeather()
            }
        }
    }

    private func loadWeather() async {
        isLoadingWeather = true
        defer { isLoadingWeather = false }
        if let snapshot = try? await service.fetchCurrent() {
            weatherSummary = snapshot.label
        }
    }
}
