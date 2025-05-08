//
//  WelcomeScreen.swift
//  MovieMenu
//
//  Created by Elena Marquez on 4/14/25.
//

import SwiftUI
import SwiftData

struct WelcomeScreen: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                VStack {
                    Text("MovieMenu")
                        .font(Font.custom("Sora-Regular_Bold", size: 50))
                        .foregroundColor(Color.lightPink)
                    Image("film")
                        .resizable()
                        .scaledToFit()
                        .frame(width: ScreenSize.width * 0.16)
                        .padding(20)
                    
                    NavigationLink(destination: AuthView(initialIsLogin: true)) {
                        WelcomeScreenButton(text: "Sign in")
                    }

                    NavigationLink(destination: AuthView(initialIsLogin: false)) {
                        WelcomeScreenButton(text: "Create account")
                    }

                }
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}
