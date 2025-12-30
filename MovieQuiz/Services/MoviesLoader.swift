//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Artur Nurtdinov on 26.12.2025.
//
import Foundation

protocol MoviesLoaderProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

class MoviesLoader: MoviesLoaderProtocol {
    private let networkClient: NetworkClientProtocol
    private let decoder = JSONDecoder()
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error): handler(.failure(error))
                case .success(let data): do {
                    let movies = try self?.decoder.decode(
                        MostPopularMovies.self,
                        from: data
                    ) ?? MostPopularMovies(errorMessage: "Failed to decode MostPopularMovies", items: [])
                    handler(.success(movies))
                } catch {
                    handler(.failure(error))
                }
                }
            }
        }
    }
}
