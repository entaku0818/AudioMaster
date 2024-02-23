//
//  AnimateViewController.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/02/19.
//

import Foundation
import UIKit
import SwiftUI

struct AnimateViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AnimateViewController {
        return AnimateViewController()
    }

    func updateUIViewController(_ uiViewController: AnimateViewController, context: Context) {
    }
}

class AnimateViewController: UIViewController {

    private var volumeVisualizerView: VolumeVisualizerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewsCount = 4
        let viewHeight: CGFloat = 80
        let viewWidth: CGFloat = self.view.bounds.width - 40 
        let startY: CGFloat = 50
        let spacing: CGFloat = 10

        for i in 0..<viewsCount {
            let animatedView = UIView(frame: CGRect(x: 20, y: startY + CGFloat(i) * (viewHeight + spacing), width: viewWidth, height: viewHeight))
            animatedView.backgroundColor = [.red, .blue, .green, .yellow][i]
            self.view.addSubview(animatedView)
            animatedView.tag = i + 1
        }


        let visualizerWidth: CGFloat = 50
        volumeVisualizerView = VolumeVisualizerView(frame: CGRect(x: 20, y: 500, width: visualizerWidth, height: 50))
        volumeVisualizerView.backgroundColor = .black
        self.view.addSubview(volumeVisualizerView)

        simulateVolumeChanges()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let delayIncrement = 0.5 // 各アニメーション開始の遅延時間を増やす
        var delay = 0.0

        for i in 0..<self.view.subviews.count {
            if let animatedView = self.view.subviews[i] as? UIView {
                // 各アニメーション開始前に遅延を設定
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    switch animatedView.tag {
                    case 1:
                        self.scaleAnimation(animatedView)
                    case 2:
                        self.colorChangeAnimation(animatedView)
                    case 3:
                        self.alphaAnimation(animatedView)
                    case 4:
                        self.rotationAnimation(animatedView)
                    default:
                        break
                    }
                }
                delay += delayIncrement // 次のアニメーションのために遅延を増やす
            }
        }
    }

    // サイズ変更アニメーション
    func scaleAnimation(_ view: UIView) {
        UIView.animate(withDuration: 1) {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        } completion: { _ in
            view.transform = .identity
        }
    }

    // 色変更アニメーション
    func colorChangeAnimation(_ view: UIView) {
        UIView.animate(withDuration: 1) {
            view.backgroundColor = .blue
        } completion: { _ in
            view.backgroundColor = .red
        }
    }

    // 透明度アニメーション
    func alphaAnimation(_ view: UIView) {
        UIView.animate(withDuration: 1) {
            view.alpha = 0.0
        } completion: { _ in
            view.alpha = 1.0
        }
    }

    // 回転アニメーション
    func rotationAnimation(_ view: UIView) {
        UIView.animate(withDuration: 1) {
            view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        } completion: { _ in
            view.transform = .identity 
        }
    }

    func simulateVolumeChanges() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            // 音の大きさをシミュレートするためにランダムな値を生成
            let randomVolumes = [CGFloat.random(in: 0.1...1.0), CGFloat.random(in: 0.1...1.0), CGFloat.random(in: 0.1...1.0)]
            self?.volumeVisualizerView.updateVolume(randomVolumes)
        }
    }

}


