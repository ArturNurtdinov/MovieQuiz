//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Artur Nurtdinov on 18.12.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
