//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Artur Nurtdinov on 17.12.2025.
//

import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    func requestNextQuestion()
    func loadData()
}

final class QuestionFactory: QuestionFactoryProtocol {
    
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoader
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoader, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies.items
                self?.delegate?.didLoadDataFromServer()
            case .failure(let error): self?.delegate?.didFailToLoadData(with: error)
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = movies[safe: index] else { return }
            
            let image = getPosterImage(movie)
            
            let rating = Float(movie.rating) ?? 0
            
            let questionText = "Рейтинг этого фильма больше чем 7?"
            
            let correctAnswer = rating > 7
            let question = QuizQuestion(
                image: image,
                text: questionText,
                correctAnswer: correctAnswer
            )
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    private func getPosterImage(_ movie: MostPopularMovie) -> Data {
        var imageData = Data()
        do {
            imageData = try Data(contentsOf: movie.resizedImageUrl)
        } catch {
            print("Failed to load image")
        }
        return imageData
    }
    
    /*
     private let questions: [QuizQuestion] = [
     QuizQuestion(
     image: "The Godfather",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "The Dark Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "Kill Bill",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "The Avengers",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "Deadpool",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "The Green Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "Old",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(
     image: "The Ice Age Adventures of Buck Wild",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(
     image: "Tesla",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(
     image: "Vivarium",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false)
     ]*/
}
