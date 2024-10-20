//
//  CreatePostView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUI
import CoreLocation
import MapKit

// Vue pour créer un nouveau post
struct CreatePostView: View {
    @State private var opponent = ""
    @State private var score = ""
    @State private var goals = ""
    @State private var assists = ""
    @State private var highlights = ""
    @State private var matchDate = Date()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedCoordinate = EquatableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522))
    @ObservedObject var postStorage = PostStorage()
    @State private var showAlert = false

    // For image picker
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false

    var body: some View {
        NavigationView {
            ZStack {
                DarkGreenGradientBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        Text("Créer un nouveau match")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top)

                        FormField(label: "Adversaire", text: $opponent)
                        FormField(label: "Score", text: $score)
                        FormField(label: "Buts", text: $goals)
                        FormField(label: "Passes dé", text: $assists)

                        FormField(label: "Description", text: $highlights)

                        // Ajout d'un sélecteur de date
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Date du match")
                                .font(.headline)
                                .foregroundColor(.white) // Texte en blanc
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                DatePicker("Date du match", selection: $matchDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding()
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                        }

                        // Image picker section
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding(.top)
                        }

                        Button(action: {
                            isImagePickerPresented.toggle()
                        }) {
                            Text("Photos")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        Text("Lieu du match:")
                            .font(.headline)
                            .foregroundColor(.white)

                        Map(coordinateRegion: $region, interactionModes: [.all], showsUserLocation: true, annotationItems: [AnnotatedLocation(coordinate: selectedCoordinate.coordinate)]) { location in
                            MapMarker(coordinate: location.coordinate, tint: .orange)
                        }
                        .frame(height: 300)
                        .cornerRadius(10)
                        .onTapGesture {
                            let newLocation = region.center
                            selectedCoordinate = EquatableCoordinate(coordinate: newLocation)
                        }

                        Button(action: savePost) {
                            Text("Enregistrer")
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
                    .navigationBarHidden(true)
                }
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .edgesIgnoringSafeArea(.all)
    }

    func savePost() {
        guard !opponent.isEmpty, !score.isEmpty, let goalsInt = Int(goals), let assistsInt = Int(assists), !highlights.isEmpty else {
            showAlert = true
            return
        }

        let mediaData = selectedImage?.jpegData(compressionQuality: 0.8)

        let newPost = FootballPost(
            date: matchDate,  // Utilisation de la date sélectionnée
            opponent: opponent,
            score: score,
            goals: goalsInt,
            assists: assistsInt,
            highlights: highlights,
            locationCoordinate: selectedCoordinate.coordinate,
            mediaData: mediaData
        )

        postStorage.addPost(newPost)

        // Reset the fields after saving the post
        opponent = ""
        score = ""
        goals = ""
        assists = ""
        highlights = ""
        selectedImage = nil
        matchDate = Date()  // Réinitialiser la date à la date actuelle
    }
}

struct AnnotatedLocation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

// Preview
struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
