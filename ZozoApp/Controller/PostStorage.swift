//
//  PostStorage.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import Foundation

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
