//
//  FormField.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUI

// Vue pour les champs de formulaire
struct FormField: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
                .foregroundColor(.white) // Texte en blanc
            TextField("", text: $text)
                .padding()
                .foregroundColor(.white) // Couleur du texte dans le champ
                .background(Color.gray.opacity(0.5)) // Couleur de fond personnalisée
                .cornerRadius(10) // Bordure arrondie
                .padding(.horizontal)
        }
    }
}
