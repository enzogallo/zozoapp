//
//  MatchView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUI


// Vue match
struct MatchView: View {
    @ObservedObject var postStorage = PostStorage()
    @State private var isCreatePostPresented = false
    @State private var selectedPost: FootballPost? = nil
    @State private var isEditPostPresented = false

    var body: some View {
        NavigationView {
            ZStack {
                DarkGreenGradientBackground()
                    .edgesIgnoringSafeArea(.all)

                if postStorage.posts.isEmpty {
                    ZStack {
                        
                        VStack {
                            // Text or message indicating no posts
                            Text("Aucun match enregistré pour le moment...")
                                .foregroundColor(.white)

                            // Animation Lottie
                            LottieView(animationName: "players_waiting")
                                .frame(width: 350, height: 600)
                        }
                            
                    }
                } else {
                    List {
                        ForEach(postStorage.posts) { post in
                            NavigationLink(destination: MatchDetailView(post: post)) {
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
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: postStorage.removePost)
                    }
                    .background(Color.clear)
                    .listStyle(PlainListStyle())
                }
            }
            .toolbar {
                if !postStorage.posts.isEmpty {
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

// Preview
struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView()
    }
}
