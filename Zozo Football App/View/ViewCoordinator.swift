//
//  ViewCoordinator.swift
//  ZozoApp
//
//  Created by Enzo Perso on 03/10/2024.
//

import SwiftUICore

struct ViewCoordinator: View {
    @State private var isActive = false
    var body: some View {
        if isActive {
            ContentView()
        }else {
            SplashScreenView(isActive: $isActive)
        }
    }
}
