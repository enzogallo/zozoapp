//
//  EditPostView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUI


// Vue pour éditer un post existant
struct EditPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var postStorage: PostStorage
    var post: FootballPost
    
    @State private var opponent: String
    @State private var score: String
    @State private var goals: String
    @State private var assists: String
    @State private var highlights: String
    @State private var selectedImage: UIImage? = nil
    @State private var showAlert = false
    @State private var selectedDate: Date

    init(postStorage: PostStorage, post: FootballPost) {
        self.postStorage = postStorage
        self.post = post
        
        // Initialiser les champs avec les valeurs du post existant
        _opponent = State(initialValue: post.opponent)
        _score = State(initialValue: post.score)
        _goals = State(initialValue: String(post.goals))
        _assists = State(initialValue: String(post.assists))
        _highlights = State(initialValue: post.highlights)
        
        // Initialiser la date avec la date du post existant
        _selectedDate = State(initialValue: post.date)
    }

    var body: some View {
        NavigationView {
            ZStack {
                DarkGreenGradientBackground()

                ScrollView {
                    VStack(spacing: 20) {

                        // Champs de formulaire
                        FormField(label: "Adversaire", text: $opponent)
                        FormField(label: "Score", text: $score)
                        FormField(label: "Buts", text: $goals)
                        FormField(label: "Passes dé", text: $assists)
                        FormField(label: "Description", text: $highlights)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Date du match")
                                .font(.headline)
                                .foregroundColor(.white) // Texte en blanc
                                

                            // Ajout d'un DatePicker pour modifier la date
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black)
                                                        
                                DatePicker("Date du match", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding()
                                    .foregroundColor(.white) // Texte du DatePicker
                            }
                            .padding(.horizontal)
                        }

                        // Afficher l'image actuelle
                        if let image = selectedImage ?? UIImage(data: post.mediaData ?? Data()) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding(.top)
                        }

                        Button(action: {
                            // Logique pour choisir une nouvelle image si nécessaire
                        }) {
                            Text("Changer Photo")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        Button(action: savePost) {
                            Text("Enregistrer les modifications")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Erreur"), message: Text("Veuillez remplir tous les champs."), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding()
                    .navigationBarTitle("Modifier le match", displayMode: .inline)
                }
            }
        }
    }

    func savePost() {
        guard !opponent.isEmpty, !score.isEmpty, let goalsInt = Int(goals), let assistsInt = Int(assists), !highlights.isEmpty else {
            showAlert = true
            return
        }

        // Convertir l'image sélectionnée (ou celle du post existant) en Data
        let mediaData = selectedImage?.jpegData(compressionQuality: 0.8) ?? post.mediaData

        let updatedPost = FootballPost(
            date: selectedDate, // Met à jour la date avec la date sélectionnée
            opponent: opponent,
            score: score,
            goals: goalsInt,
            assists: assistsInt,
            highlights: highlights,
            locationCoordinate: post.locationCoordinate,
            mediaData: mediaData
        )

        if let index = postStorage.posts.firstIndex(where: { $0.id == post.id }) {
            postStorage.posts[index] = updatedPost
            postStorage.savePosts()
        }

        presentationMode.wrappedValue.dismiss()
    }
}
