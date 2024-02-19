//
//  AnimateViewController.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/02/19.
//

import Foundation
import UIKit

class AnimateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let animatedView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        animatedView.backgroundColor = .red
        self.view.addSubview(animatedView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateView))
        animatedView.addGestureRecognizer(tapGesture)
    }

    @objc func animateView(_ sender: UITapGestureRecognizer) {
        guard let viewToAnimate = sender.view else { return }

        UIView.animateKeyframes(withDuration: 2.0, delay: 0, options: [], animations: {
            // キーフレーム1: ビューを右に移動
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                viewToAnimate.center.x += 100
            }

            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                viewToAnimate.center.y -= 100
            }

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                viewToAnimate.center = self.view.center
            }
        }, completion: nil)
    }
}
