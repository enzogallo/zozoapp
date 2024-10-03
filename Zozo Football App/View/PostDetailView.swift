//
//  PostDetailView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUI

// Vue détaillée d'un Post
struct PostDetailView: View {
    let post: FootballPost
    
    var body: some View {
        ZStack {
            DarkBlueGradientBackground()
            ScrollView { // Un seul ScrollView
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
                    
                    // Vérifiez et affichez l'image si disponible
                    if let mediaData = post.mediaData, let image = UIImage(data: mediaData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.bottom) // Ajoutez du padding pour éviter la superposition
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
        .navigationTitle("Détails du match") // Assurez-vous que le titre est défini
        .navigationBarTitleDisplayMode(.inline) // Affichez le titre en mode inline
    }
}
