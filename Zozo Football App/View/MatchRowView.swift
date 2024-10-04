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
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
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
                        .padding(.leading, 5) // Add some space
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white)
                    
                    Text(post.date, formatter: dateFormatter)
                        .font(.caption)
                        .foregroundColor(.white) // Lighter color for the date
                }
            }
            .padding(.vertical, 10) // Add vertical padding for better touch area
        }
        //.background(post.win ? Color.green.opacity(0.3) : Color.red.opacity(0.3)) // Conditional background color
        .cornerRadius(10)
        .shadow(radius: 5) // Shadow for depth
        .padding(.horizontal) // Padding on horizontal edges
        .listRowBackground(Color.clear) // Make the background of the row transparent
        .contentShape(Rectangle()) // Makes the entire row tappable
        // Here you can add a tap action to navigate to the detail view if needed
    }
}
