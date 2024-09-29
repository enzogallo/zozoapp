//
//  ContentView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 29/09/2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            TravelJournalView()
                .tabItem {
                    Label("Journal", systemImage: "book")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

// Vue pour la carte interactive avec des annotations de destinations
struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), // Paris coordinates as center
        span: MKCoordinateSpan(latitudeDelta: 20.0, longitudeDelta: 20.0)
    )
    
    // Liste des destinations avec coordonnées
    let destinations = [
        Destination(name: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)),
        Destination(name: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503)),
        Destination(name: "New York", coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)),
        Destination(name: "London", coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)),
        Destination(name: "Sydney", coordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093))
    ]

    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, annotationItems: destinations) { destination in
                MapMarker(coordinate: destination.coordinate, tint: .blue)
            }
            .navigationTitle("Travel Map")
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// Modèle pour les destinations de voyage
struct Destination: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

// Vue pour le journal de voyage (identique à la version précédente)
struct TravelJournalView: View {
    let trips = [
        "Paris Trip - 2022",
        "Tokyo Adventure - 2023",
        "New York Visit - 2021"
    ]

    var body: some View {
        NavigationView {
            List(trips, id: \.self) { trip in
                NavigationLink(destination: TripDetailView(trip: trip)) {
                    Text(trip)
                }
            }
            .navigationTitle("Travel Journal")
        }
    }
}

// Vue détaillée d'un voyage spécifique (identique à la version précédente)
struct TripDetailView: View {
    let trip: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(trip)
                .font(.title)
                .padding()

            Image(systemName: "photo.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .padding()

            Text("Trip details and description here...")
                .padding()

            Spacer()
        }
        .navigationTitle(trip)
    }
}

// Vue pour le profil utilisateur (identique à la version précédente)
struct ProfileView: View {
    let stats = [
        "Countries visited: 5",
        "Total distance: 25,000 km",
        "Longest trip: 3 weeks in Japan"
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding()

                Text("Traveler Profile")
                    .font(.title)
                    .padding()

                List(stats, id: \.self) { stat in
                    Text(stat)
                }

                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
