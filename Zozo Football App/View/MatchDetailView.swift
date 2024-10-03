//
//  PostDetailView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUI

struct MatchDetailView: View {
    let post: FootballPost
    @State private var weatherResponse: WeatherAPIResponse?
    @State private var weatherError: String?
    
    var body: some View {
        ZStack {
            DarkGreenGradientBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Spacer()
                    Text("Adversaire:  \(post.opponent)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Score: \(post.score)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Buts: \(post.goals)")
                            Text("Passes dés: \(post.assists)")
                        }
                        .foregroundColor(.white)
                        Spacer()
                    }
                    .font(.subheadline)
                    
                    // Affichage de l'image si disponible
                    if let mediaData = post.mediaData, let image = UIImage(data: mediaData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.bottom)
                    } else {
                        Text("No media available")
                            .foregroundColor(.gray)
                    }
                    
                    Text("Description:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(post.highlights)
                        .foregroundColor(.gray)
                    
                    Spacer() // Ajoutez un Spacer pour donner de l'espace à la carte

                    // Affichage des données de météo
                    if let weather = weatherResponse {
                        Text("Weather on match day:")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Condition: \(weather.forecast?.forecastday?.first?.day?.condition?.text ?? "N/A")")
                            .foregroundColor(.white)
                        
                        Text("Max Temp: \(weather.forecast?.forecastday?.first?.day?.maxtemp_c ?? 0)°C")
                            .foregroundColor(.white)
                        
                        Text("Min Temp: \(weather.forecast?.forecastday?.first?.day?.mintemp_c ?? 0)°C")
                            .foregroundColor(.white)
                    } else if let error = weatherError {
                        Text("Error fetching weather: \(error)")
                            .foregroundColor(.red)
                    } else {
                        Text("Fetching weather data...")
                            .foregroundColor(.gray)
                    }
                    
                    MapView(coordinate: post.locationCoordinate)
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding(.vertical)
                }
                .padding()
                .padding(.top, 70)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Détails du match")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchWeatherData()
        }
    }
    
    private func fetchWeatherData() {
        let weatherManager = WeatherAPIManager()
        weatherManager.fetchWeatherData(for: post) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.weatherResponse = response
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.weatherError = error.localizedDescription
                }
            }
        }
    }
}
