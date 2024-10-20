import SwiftUI

struct FormationView: View {
    @State private var playerPositions: [CGPoint] = []
    @State private var playerNames: [String] = []
    @State private var showShareSheet = false
    @State private var formationImage: UIImage?

    var body: some View {
        ZStack {
            // Gradient background at the back
            DarkGreenGradientBackground()

            // Content of the view (the scrollable part)
            ScrollView {
                VStack {
                    Text("Créer une formation")
                        .font(.title)
                        .bold()
                        .padding()

                    ZStack {
                        // Football pitch background
                        FootballPitchView()
                            .frame(width: 350, height: 350)

                        // Draggable player markers with names
                        ForEach(playerPositions.indices, id: \.self) { index in
                            VStack {
                                PlayerMarker(number: index + 1, name: playerNames[index])
                                    .position(playerPositions[index])
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                playerPositions[index] = value.location
                                            }
                                    )
                            }
                        }
                    }

                    // Name input fields
                    VStack {
                        ForEach(playerNames.indices, id: \.self) { index in
                            HStack {
                                Text("Joueur \(index + 1) :")
                                    .foregroundColor(.white)
                                TextField("Nom", text: $playerNames[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 150)
                            }
                            .padding(.bottom, 5)
                        }
                    }

                    HStack {
                        Button(action: addPlayer) {
                            Text("Ajouter")
                                .font(.headline)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        if !playerPositions.isEmpty {
                            Button(action: removePlayer) {
                                Text("Supprimer")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()

                    Button(action: exportFormation) {
                        Text("Exporter la formation")
                            .font(.headline)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .sheet(isPresented: $showShareSheet, content: {
            ShareSheet(activityItems: [formationImage as Any])
        })
    }

    // Ajouter un joueur
    func addPlayer() {
        playerPositions.append(CGPoint(x: 100, y: 100)) // Position par défaut
        playerNames.append("") // Nom vide par défaut
    }

    // Supprimer un joueur
    func removePlayer() {
        guard !playerPositions.isEmpty else { return }
        playerPositions.removeLast()
        playerNames.removeLast()
    }

    func exportFormation() {
        let pitchView = ZStack {
            FootballPitchView()
                .frame(width: 350, height: 350)

            ForEach(playerPositions.indices, id: \.self) { index in
                VStack {
                    PlayerMarker(number: index + 1, name: playerNames[index])
                        .position(playerPositions[index])
                }
            }
        }
        .frame(width: 350, height: 350)

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 350, height: 350))
        let image = renderer.image { context in
            let hostingController = UIHostingController(rootView: pitchView)
            hostingController.view.frame = CGRect(origin: .zero, size: CGSize(width: 350, height: 350))
            hostingController.view.backgroundColor = .clear

            guard let contextView = hostingController.view else { return }
            contextView.drawHierarchy(in: contextView.bounds, afterScreenUpdates: true)
        }

        formationImage = image
        showShareSheet = true
    }

}

// Football Pitch Design
struct FootballPitchView: View {
    var body: some View {
        Image("pitch") // Nom de l'image dans votre projet
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .frame(width: 350, height: 350)
    }
}

// Player Marker View with Name
struct PlayerMarker: View {
    let number: Int
    let name: String

    var body: some View {
        VStack {
            Circle()
                .fill(Color.red)
                .frame(width: 25, height: 25)

            if !name.isEmpty {
                Text(name)
                    .font(.caption)
                    .foregroundColor(.black)
                    .bold()
                    .frame(maxWidth: 50)
                    .lineLimit(1)
            }
        }
    }
}

// Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Preview
struct FormationView_Previews: PreviewProvider {
    static var previews: some View {
        FormationView()
    }
}
