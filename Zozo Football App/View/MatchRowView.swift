//
//  MatchRowView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUI
import CoreLocation

struct MatchRowView: View {
    var post: FootballPost

    var body: some View {
        HStack(spacing: 15) {
            if let mediaData = post.mediaData, let image = UIImage(data: mediaData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle()) // Pour arrondir l'image
                    .overlay(Circle().stroke(Color.white, lineWidth: 2)) // Optionnel : ajout d'une bordure
                    .shadow(radius: 5)
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(post.opponent)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text(post.score)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Text("Date: \(post.date, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.clear)
        .cornerRadius(10)
        .listRowBackground(Color.clear) // Rendre le fond de la cellule transparent
    }
}
