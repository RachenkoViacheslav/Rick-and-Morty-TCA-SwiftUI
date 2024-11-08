//
//  CharactersListView.swift
//  Rick_Morty_Test
//
//  Created by MIF Projects on 06.11.2024.
//

import SwiftUI
import ComposableArchitecture
import UIKit

@ViewAction(for: CharactersReducer.self)
struct CharactersListView: View {
    let store: StoreOf<CharactersReducer>
    
    init(store: StoreOf<CharactersReducer>) {
        self.store = store
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationStack {
            WithPerceptionTracking {
                List {
                    Group {
                        ForEach(store.items, id: \.id) { character in
                            NavigationLink {
                                CharacterDetailView(character: character)
                            } label: {
                                CharacterRow(character: character)
                                    .onAppear {
                                        if character == store.items.last {
                                            send(.didScrollToBottom)
                                        }
                                    }
                            }.foregroundColor(.white)
                        }
                    }.listRowBackground(Color(red: 0.239, green: 0.243, blue: 0.269))
                        .listRowSeparatorTint(Color.white)
                        .listRowSeparator(.hidden, edges: .top)
                    
                }.listStyle(PlainListStyle())
                
            }.background(Color(red: 0.155, green: 0.169, blue: 0.199))
            
                .navigationTitle("Characters")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Reload", systemImage: "arrow.counterclockwise") {
                            send(.refreshButtonTapped)
                        }
                    }
                }
                .onAppear {
                    send(.onAppear)
                }
        }
    }
}

#Preview {
    CharactersListView(
        store: Store(initialState: CharactersReducer.State(), reducer: { CharactersReducer() })
    )
}
