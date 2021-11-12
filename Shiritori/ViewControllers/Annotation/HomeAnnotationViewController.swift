//
//  HomeAnnotationViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/11/07.
//

import UIKit
import Gecco

class HomeAnnotationViewController: SpotlightViewController {
    // MARK: - Properties
    private var annotationViews: [UIView] = []
    private var stepIndex: Int = 0
    private var positions: [CGPoint]
    private let messages = Const.TutorialText.home
    
    // MARK: - Lifecycle
    init(positions: [CGPoint]) {
        self.positions = positions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for messageText in messages {
            addMessage(messageText: messageText)
        }
        delegate = self
    }
    // MARK: - Helpers
    private func addMessage(messageText: String) {
        let message = UILabel()
        message.text = messageText
        message.textColor = .white
        message.font = UIFont(name: Const.font, size: 20)
        message.backgroundColor = .black
        message.layer.borderWidth = 1.0
        message.layer.borderColor = UIColor.white.cgColor
        message.textAlignment = .center
        message.numberOfLines = 0
        view.addSubview(message)
        message.centerY(inView: view, constant: -50)
        message.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: 10, height: 100)
        annotationViews.append(message)
    }
    
    private func next(_ labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        
        switch stepIndex {
        case 0:
            spotlightView.appear(Spotlight.RoundedRect(center: positions[stepIndex], size: CGSize(width: 200, height: 100), cornerRadius: 10))
        case 1:
            spotlightView.appear(Spotlight.RoundedRect(center: positions[stepIndex], size: CGSize(width: 200, height: 100), cornerRadius: 10))
        case 2:
            spotlightView.move(Spotlight.Oval(center: positions[stepIndex], diameter: 100))
        case 3:
            spotlightView.move(Spotlight.Oval(center: positions[stepIndex], diameter: 100))
        case 4:
            spotlightView.move(Spotlight.Oval(center: positions[stepIndex], diameter: 100))
        case 5:
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    
    private func updateAnnotationView(_ animated: Bool) {
        annotationViews.enumerated().forEach { index, view in
            UIView.animate(withDuration: animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
        }
    }
}
// MARK: - SpotlightViewControllerDelegate Methods
extension HomeAnnotationViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        next(true)
    }
    
}
