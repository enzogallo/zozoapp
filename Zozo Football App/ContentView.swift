//
//  ContentView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 29/09/2024.
//

import SwiftUI


// Vue principale avec les onglets
struct ContentView: View {
    var body: some View {
        TabView {
            MatchView()
                .tabItem {
                    Image(systemName: "soccerball")
                    Text("Matchs")
                }
        }
        .accentColor(Color.orange) // Accentuation en orange pour les éléments interactifs
        .background(DarkGreenGradientBackground()) // Appliquer le fond avec dégradé bleu
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

// Preview pour SwiftUI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
