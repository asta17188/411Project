//
//  MovieSearch.swift
//  MovieMenu
//
//  Created by Anna Stafford on 5/1/25.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchText: String = ""
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                VStack(alignment: .leading) {
                    HStack {
                        
                        
                        Button(action: {
                            print("profile")
                        }) {
                            Image(systemName: "person")
                                .font(.title)
                        }
                    }
                    .padding()

                    TextField("Search...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    if searchText.isEmpty {
                        Text("Trending movies here...")
                            .padding()
                    } else {
                        Text("Search results for \"\(searchText)\"")
                            .padding()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}


#Preview{
    SearchView()
}
