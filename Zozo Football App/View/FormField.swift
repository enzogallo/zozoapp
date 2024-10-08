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
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black) // Couleur du texte dans le champ
                .background(Color.gray.opacity(0.2)) // Fond du champ de texte légèrement gris clair
                .padding(.horizontal)
        }
    }
}
