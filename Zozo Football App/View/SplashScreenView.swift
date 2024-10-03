//
//  SplashScreenView.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//


import SwiftUI

struct SplashScreenView: View {
    @State private var scale = 0.7
    @Binding var isActive: Bool
    var body: some View {
        ZStack {
            DarkGreenGradientBackground()
            
            VStack {
                Image("splash_app_icon")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
            }
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeIn(duration: 0.7)) {
                    self.scale = 0.9
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

// Preview pour SwiftUI
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(isActive: .constant(false))
    }
}
