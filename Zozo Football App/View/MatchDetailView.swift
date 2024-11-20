//
//  MatchDetailView.swift
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
                // Center content vertically and horizontally within VStack
                VStack(alignment: .center, spacing: 15) {
                    Spacer()

                    Text("Adversaire: \(post.opponent)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center) // Centering text

                    Text("Score: \(post.score)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center) // Centering text
                    
                    HStack {
                        // Centering the inner content
                        VStack(alignment: .center) {
                            Text("Buts: \(post.goals)")
                            Text("Passes dé: \(post.assists)")
                        }
                        .foregroundColor(.white)

                        Spacer()
                    }
                    .font(.subheadline)
                    .multilineTextAlignment(.center)

                    // Image Section: Centered in ScrollView
                    if let mediaData = post.mediaData, let image = UIImage(data: mediaData) {
                        // NavigationLink for image full screen
                        NavigationLink(destination: FullScreenImageView(image: image)) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .cornerRadius(10)
                                .padding(.bottom)
                        }
                    }
                    
                    if !post.highlights.isEmpty {
                        Text("Description:")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center) // Centering text

                        Text(post.highlights)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center) // Centering text
                    }

                    /*
                    
                    // Affichage des données de météo
                    if let weather = weatherResponse {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Météo le jour du match :")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                // Logo de l'API météo
                                if let iconCode = weather.forecast?.forecastday?.first?.day?.condition?.icon {
                                    let iconURLString = "https:" + iconCode
                                    if let iconURL = URL(string: iconURLString) {
                                        AsyncImage(url: iconURL) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 30, height: 30)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                            case .failure:
                                                Image(systemName: "exclamationmark.triangle") // Display an error image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundColor(.red)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    } else {
                                        // Handle an invalid URL if necessary
                                        Text("Invalid icon URL")
                                            .foregroundColor(.red)
                                    }
                                }


                            }
                            
                            Text("\(weather.forecast?.forecastday?.first?.day?.condition?.text ?? "N/A")")
                                .foregroundColor(.white)
                            
                            Text("\(Int(weather.forecast?.forecastday?.first?.day?.mintemp_c ?? 0))°C - \(Int(weather.forecast?.forecastday?.first?.day?.maxtemp_c ?? 0))°C")
                                .foregroundColor(.white)
                        }
                    } else if let error = weatherError {
                        Text("Erreur de récupération de la météo: \(error)")
                            .foregroundColor(.red)
                    } else {
                        Text("Récupération des données météo...")
                            .foregroundColor(.gray)
                    }
                    
                    // Affichage de la carte
                    MapView(coordinate: post.locationCoordinate)
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding(.vertical)
                        .overlay(
                            VStack {
                                Text("Lieu du Match")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(8)
                                Spacer()
                            }, alignment: .top
                        )
                     */
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensuring content takes full available space
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

struct FullScreenImageView: View {
    let image: UIImage

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .padding()
        }
    }
}
