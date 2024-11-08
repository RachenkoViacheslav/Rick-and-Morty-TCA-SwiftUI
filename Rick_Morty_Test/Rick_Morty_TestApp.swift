//
//  Rick_Morty_TestApp.swift
//  Rick_Morty_Test
//
//  Created by MIF Projects on 04.11.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct Rick_Morty_TestApp: App {
    var body: some Scene {
        WindowGroup {
            CharactersListView(
                store: Store(initialState: CharactersReducer.State(), reducer: { CharactersReducer() })
            )
        }
    }
}
