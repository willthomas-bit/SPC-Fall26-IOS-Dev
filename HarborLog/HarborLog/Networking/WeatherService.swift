import Foundation

struct WeatherSnapshot: Codable {
    var temperature: Double
    var code: Int
    var fetchedAt: Date

    var label: String {
        let rounded = Int(temperature.rounded())
        return "\(rounded) F, \(WeatherSnapshot.name(for: code))"
    }

    static func name(for code: Int) -> String {
        switch code {
        case 0: return "clear"
        case 1, 2: return "mostly clear"
        case 3: return "cloudy"
        case 45, 48: return "fog"
        case 51, 53, 55, 61, 63, 65, 80, 81, 82: return "rain"
        case 71, 73, 75, 85, 86: return "snow"
        case 95, 96, 99: return "storm"
        default: return "mixed"
        }
    }
}

struct WeatherService {
    // St. Petersburg, Florida. Open-Meteo does not need an API key.
    private let urlString = "https://api.open-meteo.com/v1/forecast?latitude=27.77&longitude=-82.64&current=temperature_2m,weather_code&temperature_unit=fahrenheit"

    func fetchCurrent() async throws -> WeatherSnapshot {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
        return WeatherSnapshot(
            temperature: decoded.current.temperature2m,
            code: decoded.current.weatherCode,
            fetchedAt: Date()
        )
    }
}

private struct OpenMeteoResponse: Decodable {
    let current: Current

    struct Current: Decodable {
        let temperature2m: Double
        let weatherCode: Int

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case weatherCode = "weather_code"
        }
    }
}
