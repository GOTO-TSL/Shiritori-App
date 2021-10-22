//
//  UsedWordViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/16.
//

import UIKit

class UsedWordViewController: UIViewController {
    
    // MARK: - Properties
    private var usedWordView: UsedWordView!
    private var backButton: UIButton!
    private var likeButton: UIButton!
    private var tableView: UITableView!
    private var usedWords: [Word]!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // headerに枠線を追加
        usedWordView.headerView.addBorder(width: 1.0, color: .white, position: .bottom)
        usedWordView.headerView.addBorder(width: 1.0, color: .white, position: .left)
        usedWordView.headerView.addBorder(width: 1.0, color: .white, position: .right)
    }
    
    private func configureUI() {
        usedWordView = UsedWordView()
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
        let resultVC = ResultViewController()
        resultVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.2, type: .push, subType: .fromLeft)
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func likePressed(_ sender: UIButton) {
        // お気に入りボタンが押されたときの処理
        let word = usedWords[sender.tag]
        presenter.didPressedLikeButton(of: word)
    }
}

// MARK: - UITableViewDataSource Methods
extension UsedWordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // カスタムセルを設定
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.CellID.used, for: indexPath) as? WordTableViewCell
        guard let safeCell = cell else { fatalError() }
        // セル選択時に色が変わらない設定
        safeCell.selectionStyle = .none
        // 単語と画像を設定
        safeCell.wordLabel.text = usedWords[indexPath.row].word
        safeCell.heartButton.imageView?.image = usedWords[indexPath.row].isLike ? UIImage(named: Const.Image.like) : UIImage(named: Const.Image.unlike)
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
        // 単語詳細画面へ移動
        let detailVC = WordDetailViewController()
        detailVC.word = usedWords[indexPath.row].word
        detailVC.mean = usedWords[indexPath.row].mean
        detailVC.modalPresentationStyle = .fullScreen
        addTransition(duration: 0.3, type: .push, subType: .fromRight)
        present(detailVC, animated: false, completion: nil)
    }
}
// MARK: - UsedWordViewProtocol Methods
extension UsedWordViewController: UsedWordViewProtocol {
    func changeCellImage(_ usedWordViewPresenter: UsedWordViewPresenter) {
        DispatchQueue.main.async {
            self.presenter.usedWordViewDidLoad()
        }
    }
    
    func showWords(_ usedWordViewPresenter: UsedWordViewPresenter, _ words: [Word]) {
        DispatchQueue.main.async {
            self.usedWords = words
            self.tableView.reloadData()
        }
    }
}
