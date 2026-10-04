import Foundation

@MainActor
final class OutingStore: ObservableObject {
    @Published var outings: [Outing] = []

    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("outings.json")
    }

    init() {
        load()
        if outings.isEmpty {
            outings = OutingStore.sample
            save()
        }
    }

    func add(_ outing: Outing) {
        outings.insert(outing, at: 0)
        save()
    }

    func update(_ outing: Outing) {
        guard let index = outings.firstIndex(where: { $0.id == outing.id }) else { return }
        outings[index] = outing
        save()
    }

    func delete(at offsets: IndexSet) {
        outings.remove(atOffsets: offsets)
        save()
    }

    func delete(_ outing: Outing) {
        outings.removeAll { $0.id == outing.id }
        save()
    }

    func save() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(outings) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let saved = try? decoder.decode([Outing].self, from: data) {
            outings = saved
        }
    }

    var averageRating: Double {
        guard !outings.isEmpty else { return 0 }
        let total = outings.reduce(0) { $0 + $1.rating }
        return Double(total) / Double(outings.count)
    }

    func countsByPlace() -> [(place: String, count: Int)] {
        let grouped = Dictionary(grouping: outings, by: \.place)
        return grouped
            .map { (place: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }

    static let sample: [Outing] = [
        Outing(title: "Morning walk", place: "St. Pete Pier", notes: "Calm water, few people out yet.", rating: 5, weatherSummary: "78 F, clear"),
        Outing(title: "Lunch break", place: "Vinoy Park", notes: "Shady bench near the water.", rating: 4, weatherSummary: "82 F, partly cloudy"),
        Outing(title: "Sunset stop", place: "Spa Beach", notes: "Wind picked up after 6.", rating: 3, weatherSummary: "80 F, breeze")
    ]
}
