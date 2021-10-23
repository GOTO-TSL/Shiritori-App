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
    var isWin: Bool?
    var mode: Mode?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        presenter = ResultViewPresenter(view: self)
        
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
        guard let safeIsWin = isWin else { return }
        guard let safeMode = mode else { return }
        if safeIsWin {
            resultLabel.text = Const.TitleText.resultWin
            resultImageView.animation(mode: safeMode, action: "result", duration: 0.7)
        } else {
            resultLabel.text = Const.TitleText.resultLose
            resultImageView.animation(mode: safeMode, action: "result", duration: 0.7)
        }
    }
    
    @objc private func homePressed(_ sender: UIButton) {
        // お気に入り以外の単語を削除
        presenter.didPressedHome()
    }
    
    @objc private func wordPressed(_ sender: UIButton) {
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
            // ホーム画面に遷移
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self.addTransition(duration: 0.3, type: .fade, subType: .fromRight)
            self.present(homeVC, animated: false, completion: nil)
        }
    }
}
