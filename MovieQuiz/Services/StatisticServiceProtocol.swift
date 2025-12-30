//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Artur Nurtdinov on 22.12.2025.
//
import Foundation

private let GAMES_COUNT_KEY = "gamesCount"
private let CORRECT_ANSWERS_KEY = "correctAnswers"
private let TOTAL_ANSWERS_KEY = "totalAnswers"
private let RECORD_DATE_KEY = "recordDate"
private let TOTAL_CORRECT_ANSWERS_KEY = "totalCorrectAnswers"
private let TOTAL_QUESTIONS_ASKED_KEY = "totalQuestionsAsked"

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    var totalCorrectAnswers: Int { get }
    var totalQuestionsAsked: Int { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: TOTAL_CORRECT_ANSWERS_KEY)
        }
        set {
            storage.set(newValue, forKey: TOTAL_CORRECT_ANSWERS_KEY)
        }
    }

    var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: TOTAL_QUESTIONS_ASKED_KEY)
        }
        set {
            storage.set(newValue, forKey: TOTAL_QUESTIONS_ASKED_KEY)
        }
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: GAMES_COUNT_KEY)
        }
        set {
            storage.set(newValue, forKey: GAMES_COUNT_KEY)
        }
    }

    var bestGame: GameResult {
        get {
            let date = storage.object(forKey: RECORD_DATE_KEY) as? Date ?? Date()
            let correct = storage.integer(forKey: CORRECT_ANSWERS_KEY)
            let total = storage.integer(forKey: TOTAL_ANSWERS_KEY)
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.date, forKey: RECORD_DATE_KEY)
            storage.set(newValue.correct, forKey: CORRECT_ANSWERS_KEY)
            storage.set(newValue.total, forKey: TOTAL_ANSWERS_KEY)
        }
    }

    var totalAccuracy: Double {
        get {
            if (totalQuestionsAsked == 0) {
                return 0.0
            }
            return Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100
        }
    }

    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        
        let currentBest = bestGame
        if (count >= currentBest.correct) {
            let currentDate = Date()
            bestGame = GameResult(correct: count, total: amount, date: currentDate)
        }
    }
}
