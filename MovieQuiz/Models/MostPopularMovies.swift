//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Artur Nurtdinov on 26.12.2025.
//
import Foundation

private let RESIZED_IMAGE_SUFFIX = "._V0_UX600_.jpg"

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageUrl: URL {
        let urlString = imageURL.absoluteString
        guard let partWithoutSize = urlString.components(separatedBy: "_")[safe: 0] else { return imageURL }
        return URL(string: partWithoutSize.appending(RESIZED_IMAGE_SUFFIX)) ?? imageURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
