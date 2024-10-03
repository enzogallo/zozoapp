//
//  FootballPost.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import Foundation
import CoreLocation

// Modèle pour un Post de football
struct FootballPost: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let opponent: String
    let score: String
    let goals: Int
    let assists: Int
    let highlights: String
    let latitude: Double
    let longitude: Double
    
    // Propriétés pour les photos/vidéos
    let mediaData: Data? // Pour stocker une photo ou une vidéo
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(date: Date, opponent: String, score: String, goals: Int, assists: Int, highlights: String, locationCoordinate: CLLocationCoordinate2D, mediaData: Data?) {
        self.date = date
        self.opponent = opponent
        self.score = score
        self.goals = goals
        self.assists = assists
        self.highlights = highlights
        self.latitude = locationCoordinate.latitude
        self.longitude = locationCoordinate.longitude
        self.mediaData = mediaData
    }
}

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

// Wrapper pour CLLocationCoordinate2D
struct EquatableCoordinate: Equatable {
    var coordinate: CLLocationCoordinate2D
    
    // Conform to Equatable by providing an equality check
    static func ==(lhs: EquatableCoordinate, rhs: EquatableCoordinate) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
