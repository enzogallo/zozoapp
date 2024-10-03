//
//  DarkBlueGradientBackground.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUICore

// Vue pour le fond avec dégradé
struct DarkBlueGradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.black]),
            startPoint: .top, endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}
