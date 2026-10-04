import Foundation

struct Outing: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var place: String
    var notes: String
    var rating: Int
    var date: Date
    var weatherSummary: String

    init(
        id: UUID = UUID(),
        title: String,
        place: String,
        notes: String,
        rating: Int,
        date: Date = Date(),
        weatherSummary: String = ""
    ) {
        self.id = id
        self.title = title
        self.place = place
        self.notes = notes
        self.rating = min(5, max(1, rating))
        self.date = date
        self.weatherSummary = weatherSummary
    }
}
