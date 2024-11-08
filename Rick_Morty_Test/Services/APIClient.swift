//
//  APIClient.swift
//  Rick_Morty_Test
//
//  Created by MIF Projects on 04.11.2024.
//

import Foundation
import Combine
import ComposableArchitecture
import Dependencies

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

@DependencyClient
struct APIClient {
    var fetchCharacters: @Sendable (URL?) async throws -> CharactersResponse
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

extension APIClient: DependencyKey {
    static let liveValue = Self(
        fetchCharacters: { page in
            let url = page ?? URL(string: "https://rickandmortyapi.com/api/character")!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            return try JSONDecoder().decode(CharactersResponse.self, from: data)
        }
    )
}
