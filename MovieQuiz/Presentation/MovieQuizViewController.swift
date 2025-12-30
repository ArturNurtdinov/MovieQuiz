import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private let questionsAmount: Int = 10
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    private let alertPresenter: AlertPresenter = AlertPresenterImpl()
    private let statisticService: StatisticServiceProtocol = StatisticService()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    @IBOutlet weak var counterLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(
            moviesLoader: MoviesLoader(networkClient: NetworkClient()),
            delegate: self
        )
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        
        currentQuestion = question
        let currentState = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: currentState)
        }
    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if (isCorrect) {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
            self?.goToNextStep()
        })
    }
    
    private func goToNextStep() {
        if (currentQuestionIndex < questionsAmount - 1) {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        } else {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: getResultMessage(),
                buttonText: "Сыграть еще раз",
                completion: { [weak self] in
                    guard let self = self else { return }
                    self.currentQuestionIndex = 0 // 1
                    
                    correctAnswers = 0
                    currentQuestionIndex = 0
                    questionFactory?.requestNextQuestion()
                }
            )
            alertPresenter.show(in: self, model: alertModel)
        }
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showLoadingIndicator() {
        loaderView.isHidden = false
        loaderView.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loaderView.isHidden = true
        loaderView.stopAnimating()
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
        alertPresenter.show(in: self, model: alert)
    }
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func getResultMessage() -> String {
        return """
            Ваш результат \(correctAnswers)/\(questionsAmount).
            Количество сыгранных квизов: \(statisticService.gamesCount).
            Рекорд - \(statisticService.bestGame.correct)/\(questionsAmount).
            Средняя точность - \("\(String(format: "%.2f", statisticService.totalAccuracy))%").
        """
    }
}
