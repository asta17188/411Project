//
//  Styles.swift
//  MovieMenu
//
//  Created by Elena Marquez on 4/16/25.
//

import Foundation
import SwiftUI

struct ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

struct AppBackground: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(EllipticalGradient(
                stops: [
                    Gradient.Stop(color: .black.opacity(0), location: 0.00),
                    Gradient.Stop(color: .black, location: 1.8),
                ], center: UnitPoint(x: 0.5, y: 0.5)))
            .background(Color.englishViolet)
            .ignoresSafeArea()
    }
}

struct WelcomeScreenButton: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
          Text(text)
            .font(Font.custom("Sora-Regular_SemiBold", size: 25))
            .lineSpacing(16)
            .foregroundColor(Color.lightPink)
        }
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
        .frame(width: ScreenSize.width * 0.65)
        .cornerRadius(12)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .inset(by: 1)
            .stroke(Color.lightPink, lineWidth: 2)
        )
        .shadow(
          color: Color(red: 0.38, green: 0.38, blue: 0.44, opacity: 0.1), radius: 15, y: 8
        )
        .padding(25)
    }
}

#Preview {
    WelcomeScreen()
}
