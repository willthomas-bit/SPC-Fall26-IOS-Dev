import SwiftUI

struct WeatherView: View {
    @State private var snapshot: WeatherSnapshot?
    @State private var errorMessage = ""
    @State private var isLoading = false

    private let service = WeatherService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: iconName)
                    .font(.system(size: 64))
                    .foregroundStyle(Color.accentColor)
                if isLoading {
                    ProgressView("Contacting Open-Meteo")
                } else if let snapshot {
                    Text(snapshot.label)
                        .font(.title2)
                    Text("St. Petersburg, Florida")
                        .foregroundStyle(.secondary)
                    Text("Fetched \(snapshot.fetchedAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else {
                    Text(errorMessage.isEmpty ? "No weather yet." : errorMessage)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                Button("Fetch again") {
                    Task { await load() }
                }
                .buttonStyle(.borderedProminent)
                Text("This screen sends an HTTPS GET to api.open-meteo.com and decodes the JSON into a small model.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Weather")
            .task {
                await load()
            }
        }
    }

    private var iconName: String {
        guard let snapshot else { return "cloud.sun" }
        switch snapshot.code {
        case 0, 1: return "sun.max"
        case 2, 3: return "cloud.sun"
        case 51, 53, 55, 61, 63, 65, 80, 81, 82: return "cloud.rain"
        case 95, 96, 99: return "cloud.bolt"
        default: return "cloud"
        }
    }

    private func load() async {
        isLoading = true
        errorMessage = ""
        defer { isLoading = false }
        do {
            snapshot = try await service.fetchCurrent()
        } catch {
            errorMessage = "Could not reach the weather service. Check the simulator network and try again."
        }
    }
}
