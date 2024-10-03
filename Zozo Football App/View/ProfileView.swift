//
//  ProfileView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUI

// Vue pour le profil
struct ProfileView: View {
    @ObservedObject var postStorage = PostStorage() // Observer les posts

    // Calcul des statistiques
    private var totalMatches: Int {
        postStorage.posts.count
    }

    private var totalGoals: Int {
        postStorage.posts.reduce(0) { $0 + $1.goals }
    }

    private var totalAssists: Int {
        postStorage.posts.reduce(0) { $0 + $1.assists }
    }

    var body: some View {
        ZStack {
            // Appliquer le fond dégradé
            DarkGreenGradientBackground()
            
            VStack(alignment: .leading) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding()

                Text("Profil")
                    .font(.title)
                    .foregroundColor(.white) // Texte blanc pour contraste
                    .padding()

                // Affichage des statistiques
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Matches: \(totalMatches)")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Total Goals: \(totalGoals)")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Total Assists: \(totalAssists)")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()

                // Liste des posts
                List(postStorage.posts) { post in
                    NavigationLink(destination: MatchDetailView(post: post)) {
                        VStack(alignment: .leading) {
                            Text("\(post.opponent) - \(post.score)")
                                .font(.headline)
                                .foregroundColor(.white) // Texte en blanc pour le contraste
                            Text("Date: \(post.date, formatter: dateFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2)) // Fond gris clair pour les cellules
                        .cornerRadius(10)
                    }
                }
                .listStyle(PlainListStyle()) // Empêche les séparateurs par défaut
                .background(Color.clear) // Fond transparent pour la liste
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Profil")
    }
}
