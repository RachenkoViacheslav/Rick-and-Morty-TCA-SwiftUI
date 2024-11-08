//
//  CharactersReducer.swift
//  Rick_Morty_Test
//
//  Created by MIF Projects on 05.11.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CharactersReducer {
    @Dependency(\.dataBaseService) var database
    @Dependency(\.apiClient.fetchCharacters) var loadCharacters
    
    @ObservableState
    struct State: Equatable {
        var nextPage: URL?
        var items: [Character] = []
        var isLoading: Bool = false
        var selectedCharacter: Character?
    }
    
    enum Action: ViewAction {
        case view(View)
        case fetchCharacters
        case loadNextPage
        case reloadData
        case fetchCharactersCompleted(TaskResult<CharactersResponse>)
        
        case cacheResponse(CharactersResponse)
        case loadStoredCharacters
        case loadedStoredCharacters([Character], nextPage: URL?)
        
        enum View {
            case onAppear
            case didScrollToBottom
            case refreshButtonTapped
            case onSelect(Character)
        }
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .view(let action):
            switch action {
            case .onAppear:
                return .send(.loadStoredCharacters)
            case .didScrollToBottom:
                return .send(.loadNextPage)
            case .refreshButtonTapped:
                return .send(.reloadData)
            case .onSelect(let character):
                state.selectedCharacter = character
                return .none
            }
            
        case .reloadData:
            state.items.removeAll()
            return .run { send in
                try? await database.deleteAll()
                await send(.fetchCharacters)
            }
            
        case .fetchCharactersCompleted(let result):
            state.isLoading = false
            
            switch result {
            case .success(let result):
                if state.nextPage != nil {
                    state.items += result.results
                } else {
                    state.items = result.results
                }
                
                state.nextPage = result.info.next
                
                return .send(.cacheResponse(result))
                
            case .failure(let error):
                print("FAILED")
                print(error)
                return .none
            }
            
        case .cacheResponse(let response):
            return .run { send in
                try? await database.saveCharacters(response.results)
                try? await database.savePageInfo(response.info)
            }
            
        case .loadStoredCharacters:
            return .run { send in
                let storedCharacters = await database.getAllCharacters().map {
                    Character(
                        id: $0.id,
                        name: $0.name,
                        status: Character.Status(rawValue: $0.status) ?? .unknown,
                        species: $0.species,
                        type: $0.type,
                        gender: $0.gender,
                        image: URL(string: $0.imageUrl)!,
                        location: Character.Location(name: $0.location?.name ?? "unknown", url: $0.location?.url ?? ""),
                        origin: Character.Origin(name: $0.origin?.name ?? "unknown", url: $0.origin?.url ?? "")
                    )
                }
                
                let storedPage = await database.loadPageInfo()
                let nextPage = storedPage.next.flatMap { URL(string: $0) }
                
                await send(.loadedStoredCharacters(storedCharacters, nextPage: nextPage))
            }
        case .fetchCharacters:
            state.isLoading = true
            return .run { send in
                let result = try await loadCharacters(nil)
                await send(.fetchCharactersCompleted(TaskResult { result } ))
            }
            
        case .loadNextPage:
            guard let nextPage = state.nextPage else { return .none }
            
            state.isLoading = true
            return .run { send in
                let result = try await loadCharacters(nextPage)
                await send(.fetchCharactersCompleted(TaskResult { result } ))
            }
            
        case .loadedStoredCharacters(let items, let nextPage):
            state.items = items
            state.nextPage = nextPage
            return items.isEmpty ? .send(.fetchCharacters) : .none
        }
    }
}
