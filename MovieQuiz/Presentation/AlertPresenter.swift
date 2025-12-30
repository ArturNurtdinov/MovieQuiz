//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Artur Nurtdinov on 18.12.2025.
//

import Foundation
import UIKit

protocol AlertPresenter: AnyObject {
    func show(in vc: UIViewController, model: AlertModel)
}

class AlertPresenterImpl: AlertPresenter {
    
    func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default
        ) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
