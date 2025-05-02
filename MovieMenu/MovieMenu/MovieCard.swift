//
//  MovieCard.swift
//  MovieMenu
//
//  Created by Anna Stafford on 5/1/25.
//

import SwiftUI
import SwiftData

struct Cardview: View {
    //placeholder
    let imageUrl = URL(string:"https://creativereview.imgix.net/content/uploads/2024/12/AlienRomulus-scaled.jpg?auto=compress,format&q=60&w=729&h=1080")
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top){
                AppBackground()
                ZStack {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 350)
                            .padding(.top,70)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    Text("Title")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 140)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                    Text("Director")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 210)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Synopsis")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 280)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    //return to previous screen
                    print("Back button tapped")
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    //.padding(.bottom)
                        .padding(.leading, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                Button(action: {
                    print("add movie")
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                    //.padding(.top, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            
            
            
            
            
        }
    }
}
#Preview {
    Cardview()
}
