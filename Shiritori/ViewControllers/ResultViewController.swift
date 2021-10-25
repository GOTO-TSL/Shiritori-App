//
//  ResultViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/17.
//

import UIKit

class ResultViewController: UIViewController {
    
    // MARK: - Properties
    private var resultView: ResultView!
    private var homeButton: UIButton!
    private var wordButton: UIButton!
    private var resultLabel: UILabel!
    private var resultImageView: UIImageView!
    
    private var presenter: ResultViewPresenter!
    private var isWin = UserDefaults.standard.bool(forKey: Const.UDKeys.isWin)
    private let mode: Mode? = UserDefaults.standard.getEnum(forKey: Const.UDKeys.currentMode)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        presenter = ResultViewPresenter(view: self)
        presenter.resultViewDidLoad(isWin: isWin)
    }
    
    private func configureUI() {
        resultView = ResultView()
        homeButton = resultView.buttons.homeButton
        wordButton = resultView.buttons.wordButton
        resultLabel = resultView.titleView.title
        resultImageView = resultView.imageView.resultImageView
        
        setResult()
        
        // 配置＆制約
        view.addSubview(resultView)
        resultView.addConstraintsToFillView(view)
        
        // 各ボタンにアクションを追加
        homeButton.addTarget(self, action: #selector(homePressed(_:)), for: .touchUpInside)
        wordButton.addTarget(self, action: #selector(wordPressed(_:)), for: .touchUpInside)
    }
    
    private func setResult() {
        if isWin {
            resultLabel.text = Const.TitleText.resultWin
            resultImageView.animation(mode: mode!, action: "result", duration: 0.7)
        } else {
            resultLabel.text = Const.TitleText.resultLose
            resultImageView.animation(mode: mode!, action: "result", duration: 0.7)
        }
    }
    
    @objc private func homePressed(_ sender: UIButton) {
        // お気に入り以外の単語を削除
        presenter.didPressedHome()
    }
    
    @objc private func wordPressed(_ sender: UIButton) {
        presenter.didPressedWord()
        // 使用した単語一覧画面に遷移
        let usedWordVC = UsedWordViewController()
        usedWordVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .moveIn, subType: .fromBottom)
        present(usedWordVC, animated: false, completion: nil)
    }
}
// MARK: - ResultViewProtocol Methods
extension ResultViewController: ResultViewProtocol {
    func goToNextView(_ resultViewPresenter: ResultViewPresenter) {
        DispatchQueue.main.async {
            self.opening(operation: .play)
            // ホーム画面に遷移
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self.addTransition(duration: 0.3, type: .fade, subType: .fromRight)
            self.present(homeVC, animated: false, completion: nil)
        }
    }
}
