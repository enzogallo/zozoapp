//
//  ContentView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 29/09/2024.
//

import SwiftUI
import MapKit
import CoreLocation

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
    let improvements: String
    let locationName: String
    let latitude: Double // Propriété pour la latitude
    let longitude: Double // Propriété pour la longitude

    // Calculer les coordonnées à partir de latitude et longitude
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // Initialisateur pour faciliter la création d'un post à partir de CLLocationCoordinate2D
    init(date: Date, opponent: String, score: String, goals: Int, assists: Int, highlights: String, improvements: String, locationName: String, locationCoordinate: CLLocationCoordinate2D) {
        self.date = date
        self.opponent = opponent
        self.score = score
        self.goals = goals
        self.assists = assists
        self.highlights = highlights
        self.improvements = improvements
        self.locationName = locationName
        self.latitude = locationCoordinate.latitude
        self.longitude = locationCoordinate.longitude
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
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "house.fill")
                }
            CreatePostView()
                .tabItem {
                    Label("Create", systemImage: "plus.circle.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
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

// Vue pour le fil d'actualité (Feed)
struct FeedView: View {
    @ObservedObject var postStorage = PostStorage()

    var body: some View {
        NavigationView {
            ZStack {
                DarkBlueGradientBackground() // Appliquer le fond à l'intérieur de NavigationView

                List {
                    ForEach(postStorage.posts) { post in
                        NavigationLink(destination: PostDetailView(post: post)) {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(post.opponent)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white) // Texte en blanc pour contraste
                                    Spacer()
                                    Text(post.score)
                                        .font(.subheadline)
                                        .foregroundColor(.gray) // Texte gris
                                }
                                Text("Location: \(post.locationName)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("Date: \(post.date, formatter: dateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2)) // Fond gris clair pour les cellules
                            .cornerRadius(10) // Coins arrondis pour un style moderne
                        }
                    }
                    .onDelete(perform: postStorage.removePost) // Permet de supprimer un post
                }
                .listStyle(PlainListStyle()) // Empêche l'utilisation du fond blanc par défaut des sections
                .background(Color.clear) // S'assure que la liste soit transparente
                .navigationTitle("Match History") // Nouveau titre pour le Feed
                .toolbar {
                    EditButton() // Bouton d'édition pour supprimer les posts
                }
            }
        }
        .edgesIgnoringSafeArea(.all) // Ignore les bords pour que le fond dégradé prenne toute la vue
    }
}


// Vue détaillée d'un Post
struct PostDetailView: View {
    let post: FootballPost
    
    var body: some View {
        ZStack {
            DarkBlueGradientBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Opponent: \(post.opponent)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Score: \(post.score)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Goals: \(post.goals)")
                            Text("Assists: \(post.assists)")
                        }
                        .foregroundColor(.white)
                        Spacer()
                    }
                    .font(.subheadline)
                    
                    MapView(coordinate: post.locationCoordinate)
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding(.vertical)

                    Text("Highlights:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(post.highlights)
                        .foregroundColor(.gray)
                    
                    Text("Improvements:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(post.improvements)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Match Details")
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// Vue pour créer un nouveau post
struct CreatePostView: View {
    @State private var opponent = ""
    @State private var score = ""
    @State private var goals = ""
    @State private var assists = ""
    @State private var highlights = ""
    @State private var improvements = ""
    @State private var locationName = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedCoordinate = EquatableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522))
    @ObservedObject var postStorage = PostStorage()
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                DarkBlueGradientBackground() // Appliquer le fond à l'intérieur de NavigationView

                ScrollView {
                    VStack(spacing: 20) {
                        Text("Create New Post")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white) // Texte en blanc pour le contraste
                            .padding(.top)

                        FormField(label: "Opponent", text: $opponent)
                        FormField(label: "Score (e.g., 3-2)", text: $score)
                        FormField(label: "Goals", text: $goals)
                        FormField(label: "Assists", text: $assists)

                        FormField(label: "Highlights", text: $highlights)
                        FormField(label: "Improvements", text: $improvements)

                        TextField("Location Name", text: $locationName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.white) // Couleur du texte dans le champ
                            .background(Color.gray.opacity(0.2)) // Fond du champ de texte légèrement gris clair
                            .padding(.horizontal)

                        Text("Select Match Location:")
                            .font(.headline)
                            .foregroundColor(.white) // Texte en blanc

                        // Carte avec sélection de lieu
                        Map(coordinateRegion: $region, interactionModes: [.all], showsUserLocation: true, annotationItems: [AnnotatedLocation(coordinate: selectedCoordinate.coordinate)]) { location in
                            MapMarker(coordinate: location.coordinate, tint: .orange) // Marqueur orange
                        }
                        .frame(height: 300)
                        .cornerRadius(10)
                        .onTapGesture {
                            let newLocation = region.center
                            selectedCoordinate = EquatableCoordinate(coordinate: newLocation)
                        }

                        Button(action: savePost) {
                            Text("Save Post")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Error"), message: Text("Please fill in all the fields."), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding()
                    .navigationBarHidden(true)
                }
            }
        }
        .edgesIgnoringSafeArea(.all) // Le fond prendra tout l'écran
    }

    func savePost() {
        guard !opponent.isEmpty, !score.isEmpty, let goalsInt = Int(goals), let assistsInt = Int(assists), !highlights.isEmpty, !improvements.isEmpty, !locationName.isEmpty else {
            showAlert = true
            return
        }
        
        let newPost = FootballPost(
            date: Date(),
            opponent: opponent,
            score: score,
            goals: goalsInt,
            assists: assistsInt,
            highlights: highlights,
            improvements: improvements,
            locationName: locationName,
            locationCoordinate: selectedCoordinate.coordinate
        )
        postStorage.addPost(newPost)
        
        // Réinitialiser les champs après l'ajout du post
        opponent = ""
        score = ""
        goals = ""
        assists = ""
        highlights = ""
        improvements = ""
        locationName = ""
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

                Text("Profile")
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
        .navigationTitle("Profile")
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
                .foregroundColor(.white) // Couleur du texte dans le champ
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

// Preview pour SwiftUI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
