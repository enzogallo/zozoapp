//
//  ContentView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 29/09/2024.
//

import SwiftUI
import MapKit
import CoreLocation
import UIKit
import PhotosUI

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

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


// Wrapper pour CLLocationCoordinate2D
struct EquatableCoordinate: Equatable {
    var coordinate: CLLocationCoordinate2D
    
    // Conform to Equatable by providing an equality check
    static func ==(lhs: EquatableCoordinate, rhs: EquatableCoordinate) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

// Vue principale avec les onglets
struct ContentView: View {
    var body: some View {
        TabView {
            MatchView()
                .tabItem {
                    Image(systemName: "soccerball")
                    Text("Matchs")
                }
        }
        .accentColor(Color.orange) // Accentuation en orange pour les éléments interactifs
        .background(DarkBlueGradientBackground()) // Appliquer le fond avec dégradé bleu
    }
}

// Gestion du stockage des posts dans UserDefaults
class PostStorage: ObservableObject {
    @Published var posts: [FootballPost] = []
    
    init() {
        loadPosts()
    }

    // Sauvegarder les posts dans UserDefaults
    func savePosts() {
        if let encoded = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(encoded, forKey: "footballPosts")
        }
    }

    // Charger les posts depuis UserDefaults
    func loadPosts() {
        if let savedPosts = UserDefaults.standard.data(forKey: "footballPosts"),
           let decodedPosts = try? JSONDecoder().decode([FootballPost].self, from: savedPosts) {
            self.posts = decodedPosts
        }
    }

    // Ajouter un nouveau post
    func addPost(_ post: FootballPost) {
        posts.append(post)
        savePosts()
    }

    // Supprimer un post
    func removePost(at offsets: IndexSet) {
        posts.remove(atOffsets: offsets)
        savePosts()
    }
}

struct MatchRowView: View {
    var post: FootballPost

    var body: some View {
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
        .padding()
        .background(Color.clear)
        .cornerRadius(10)
        .listRowBackground(Color.clear) // Rendre le fond de la cellule transparent
    }
}


// Vue match
struct MatchView: View {
    @ObservedObject var postStorage = PostStorage()
    @State private var isCreatePostPresented = false
    @State private var selectedPost: FootballPost? = nil
    @State private var isEditPostPresented = false

    var body: some View {
        NavigationView {
            ZStack {
                DarkBlueGradientBackground()
                    .edgesIgnoringSafeArea(.all)

                List {
                    ForEach(postStorage.posts) { post in
                        NavigationLink(destination: PostDetailView(post: post)) {
                            MatchRowView(post: post)
                        }
                        .contextMenu {
                            Button(action: {
                                selectedPost = post
                                isEditPostPresented = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Modifier")
                                }
                            }
                            .padding()
                            .background(Color.clear) // S'assurer que le fond de chaque cellule est transparent
                            .cornerRadius(10)
                        }
                        // Appliquer un fond transparent à chaque cellule de la liste
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: postStorage.removePost)
                }
                .background(Color.clear)
                .listStyle(PlainListStyle())
                .navigationTitle("Matchs")
                .toolbar {
                    EditButton()
                }
            }
            .overlay(
                Button(action: {
                    isCreatePostPresented.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding(.bottom, 30)
                .padding(.trailing, 20),
                alignment: .bottomTrailing
            )
        }
        .sheet(isPresented: $isCreatePostPresented) {
            CreatePostView()
        }
        .sheet(item: $selectedPost) { post in
            EditPostView(postStorage: postStorage, post: post)
        }
        .edgesIgnoringSafeArea(.all)
    }
}


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

    init(postStorage: PostStorage, post: FootballPost) {
        self.postStorage = postStorage
        self.post = post
        
        // Initialiser les champs avec les valeurs du post existant
        _opponent = State(initialValue: post.opponent)
        _score = State(initialValue: post.score)
        _goals = State(initialValue: String(post.goals))
        _assists = State(initialValue: String(post.assists))
        _highlights = State(initialValue: post.highlights)
    }

    var body: some View {
        NavigationView {
            ZStack {
                DarkBlueGradientBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        Text("Modifier le post")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top)

                        // Modifie la couleur ici pour chaque champ de formulaire
                        FormField(label: "Adversaire", text: $opponent)
                            .foregroundColor(.black) // Couleur noire
                        FormField(label: "Score", text: $score)
                            .foregroundColor(.black) // Couleur noire
                        FormField(label: "Buts", text: $goals)
                            .foregroundColor(.black) // Couleur noire
                        FormField(label: "Passes dé", text: $assists)
                            .foregroundColor(.black) // Couleur noire
                        FormField(label: "Description", text: $highlights)
                            .foregroundColor(.black) // Couleur noire

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
                    .navigationBarTitle("Édition de Post", displayMode: .inline)
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
            date: post.date,
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


// Vue pour créer un nouveau post
struct CreatePostView: View {
    @State private var opponent = ""
    @State private var score = ""
    @State private var goals = ""
    @State private var assists = ""
    @State private var highlights = ""
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
                DarkBlueGradientBackground()

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
            date: Date(),
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
    }
}


struct AnnotatedLocation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

// Vue pour le profil
struct ProfileView: View {
    @ObservedObject var postStorage = PostStorage() // Observer les posts

    // Calcul des statistiques
    private var totalMatches: Int {
        postStorage.posts.count
    }

    private var totalGoals: Int {
        postStorage.posts.reduce(0) { $0 + $1.goals }
    }

    private var totalAssists: Int {
        postStorage.posts.reduce(0) { $0 + $1.assists }
    }

    var body: some View {
        ZStack {
            // Appliquer le fond dégradé
            DarkBlueGradientBackground()
            
            VStack(alignment: .leading) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding()

                Text("Profil")
                    .font(.title)
                    .foregroundColor(.white) // Texte blanc pour contraste
                    .padding()

                // Affichage des statistiques
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Matches: \(totalMatches)")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Total Goals: \(totalGoals)")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Total Assists: \(totalAssists)")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()

                // Liste des posts
                List(postStorage.posts) { post in
                    NavigationLink(destination: PostDetailView(post: post)) {
                        VStack(alignment: .leading) {
                            Text("\(post.opponent) - \(post.score)")
                                .font(.headline)
                                .foregroundColor(.white) // Texte en blanc pour le contraste
                            Text("Date: \(post.date, formatter: dateFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2)) // Fond gris clair pour les cellules
                        .cornerRadius(10)
                    }
                }
                .listStyle(PlainListStyle()) // Empêche les séparateurs par défaut
                .background(Color.clear) // Fond transparent pour la liste
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Profil")
    }
}

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

// Vue pour afficher une carte
struct MapView: View {
    var coordinate: CLLocationCoordinate2D

    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))))
            .cornerRadius(10)
    }
}

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

// DateFormatter pour formater les dates dans les Posts
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false // Set to true if you want to allow image editing
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


// Preview pour SwiftUI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
