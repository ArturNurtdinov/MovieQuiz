//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Artur Nurtdinov on 22.12.2025.
//
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isHigherThan(_ other: GameResult) -> Bool {
        return self.correct > other.correct
    }
}
