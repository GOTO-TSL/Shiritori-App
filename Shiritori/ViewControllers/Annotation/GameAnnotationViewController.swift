//
//  GameAnnotationViewController.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/11/07.
//

import UIKit
import Gecco

class GameAnnotationViewController: SpotlightViewController {
    
    var annotationViews: [UIView] = []
    var stepIndex: Int = 0
    var positions: [CGPoint]
    let messages = Const.TutorialText.game
    
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
    
    func addMessage(messageText: String) {
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
        message.centerY(inView: view, constant: 80)
        message.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: 10, height: 100)
        annotationViews.append(message)
    }
    
    func next(_ labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        
        switch stepIndex {
        case 0:
            spotlightView.appear(Spotlight.RoundedRect(center: positions[stepIndex], size: CGSize(width: view.frame.width*0.65, height: view.frame.height*0.2), cornerRadius: 10))
        case 1:
            spotlightView.appear(Spotlight.RoundedRect(center: positions[stepIndex], size: CGSize(width: view.frame.width*0.75, height: view.frame.height*0.1), cornerRadius: 10))
        case 2:
            spotlightView.move(Spotlight.Oval(center: positions[stepIndex], diameter: 80))
        case 3:
            spotlightView.appear(Spotlight.RoundedRect(center: positions[stepIndex], size: CGSize(width: view.frame.width*0.45, height: view.frame.height*0.07), cornerRadius: 10))
        case 4:
            spotlightView.move(Spotlight.Oval(center: positions[stepIndex], diameter: 100))
        case 5:
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    
    func updateAnnotationView(_ animated: Bool) {
        annotationViews.enumerated().forEach { index, view in
            UIView.animate(withDuration: animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
        }
    }
}

extension GameAnnotationViewController: SpotlightViewControllerDelegate {
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
