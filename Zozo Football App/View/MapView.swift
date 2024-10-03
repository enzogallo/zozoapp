//
//  MapView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUI
import CoreLocation
import MapKit

// Vue pour afficher une carte
struct MapView: View {
    var coordinate: CLLocationCoordinate2D

    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))))
            .cornerRadius(10)
    }
}
