//
//  ContentView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 29/09/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FootballView()
                .tabItem {
                    Label("Football", systemImage: "soccerball")
                }

            TravelView()
                .tabItem {
                    Label("Travel", systemImage: "airplane")
                }

            MusicView()
                .tabItem {
                    Label("Music", systemImage: "music.note")
                }
        }
    }
}

struct FootballView: View {
    let teams = ["Manchester United", "FC Barcelona", "Liverpool FC", "Paris Saint-Germain", "Bayern Munich"]

    var body: some View {
        NavigationView {
            List(teams, id: \.self) { team in
                Text(team)
            }
            .navigationTitle("Football Teams")
        }
    }
}

struct TravelView: View {
    let destinations = ["Paris", "Tokyo", "New York", "London", "Sydney"]

    var body: some View {
        NavigationView {
            List(destinations, id: \.self) { destination in
                Text(destination)
            }
            .navigationTitle("Travel Destinations")
        }
    }
}

struct MusicView: View {
    let songs = ["Song 1 - Artist A", "Song 2 - Artist B", "Song 3 - Artist C", "Song 4 - Artist D"]

    var body: some View {
        NavigationView {
            List(songs, id: \.self) { song in
                Text(song)
            }
            .navigationTitle("Favorite Songs")
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
