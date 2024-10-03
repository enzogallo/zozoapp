import Foundation

class WeatherAPIManager {
    private let baseURL = "https://api.weatherapi.com/v1/history.json"
    private let apiKey = "fcd90a11ffcc4f80934200608240310" // Replace with your API key

    func fetchWeatherData(for post: FootballPost, completion: @escaping (Result<WeatherAPIResponse, Error>) -> Void) {
        let latitude = post.latitude
        let longitude = post.longitude
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: post.date)
        
        let urlString = "\(baseURL)?key=\(apiKey)&q=\(latitude),\(longitude)&dt=\(formattedDate)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}


struct WeatherAPIResponse: Codable {
    let location: Location?
    let forecast: Forecast?
}

struct Location: Codable {
    let name: String?
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let timezone: String?
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]?
}

struct ForecastDay: Codable {
    let date: String?
    let day: Day?
}

struct Day: Codable {
    let maxtemp_c: Double?
    let mintemp_c: Double?
    let condition: Condition?
}

struct Condition: Codable {
    let text: String?
    let icon: String?
}
