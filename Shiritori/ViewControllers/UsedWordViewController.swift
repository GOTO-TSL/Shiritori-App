//
//  UsedWordViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/16.
//

import UIKit

class UsedWordViewController: UIViewController {
    
    // MARK: - Properties
    private var backButton: UIButton!
    private var likeButton: UIButton!
    private var tableView: UITableView!
    
    private var presenter: UsedWordViewPresenter!
    
    // ステータスバーの色を白に設定
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        presenter = UsedWordViewPresenter(view: self)
        presenter.usedWordViewDidLoad()
        
    }
    
    private func configureUI() {
        let usedWordView = UsedWordView()
        backButton = usedWordView.headerView.backButton
        tableView = usedWordView.tableView
        
        // 配置＆制約の追加
        view.addSubview(usedWordView)
        usedWordView.addConstraintsToFillView(view)
        
        // delegateの設定
        tableView.dataSource = self
        tableView.delegate = self
        
        // ボタンにアクションを追加
        backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func backPressed(_ sender: UIButton) {
        // リザルト画面に戻る
        addTransition(duration: 0.2, type: .push, subType: .fromLeft)
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func likePressed(_ sender: UIButton) {
        // お気に入りボタンが押されたときの処理
        guard let word = presenter.usedWord(forRow: sender.tag) else { fatalError() }
        presenter.didPressedLikeButton(of: word)
    }
}

// MARK: - UITableViewDataSource Methods
extension UsedWordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfWords
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // カスタムセルを設定
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.CellID.used, for: indexPath) as? WordTableViewCell
        guard let safeCell = cell else { fatalError() }
        // セル選択時に色が変わらない設定
        safeCell.selectionStyle = .none
        // 単語と画像を設定
        guard let usedWord = presenter.usedWord(forRow: indexPath.row) else { fatalError() }
        safeCell.wordLabel.text = usedWord.word
        safeCell.heartButton.imageView?.image = usedWord.isLike ? UIImage(named: Const.Image.like) : UIImage(named: Const.Image.unlike)
        // お気に入りボタンの設定
        likeButton = safeCell.heartButton
        likeButton.tag = indexPath.row
        likeButton.addTarget(self, action: #selector(likePressed(_:)), for: .touchUpInside)
        
        return safeCell
    }
}
// MARK: - UITableViewDelegate Methods
extension UsedWordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let usedWord = presenter.usedWord(forRow: indexPath.row) else { fatalError() }
        // 単語詳細画面へ移動
        let detailVC = WordDetailViewController()
        detailVC.word = usedWord.word
        detailVC.mean = usedWord.mean
        detailVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .push, subType: .fromRight)
        present(detailVC, animated: false, completion: nil)
    }
}
// MARK: - UsedWordViewProtocol Methods
extension UsedWordViewController: UsedWordViewProtocol {
    func didFeatchWord(_ usedWordViewPresenter: UsedWordViewPresenter) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.reloadData()
        }
    }
}
