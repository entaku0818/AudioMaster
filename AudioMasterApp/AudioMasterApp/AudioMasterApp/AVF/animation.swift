//
//  animation.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/04/14.
//

import Foundation
import UIKit

class CoreAnimationViewController: UIViewController {

    // アニメーションさせるビューを作成
    let dancingImageView = UIImageView()
    let backGroundDancingImageView = UIImageView()


    override func viewDidLoad() {
        super.viewDidLoad()

        // UIImageViewの設定
        dancingImageView.frame = CGRect(x: 150, y: 200, width: 100, height: 100)
        dancingImageView.contentMode = .scaleAspectFit // 画像のアスペクト比を保持
        // UIImageViewの設定
        backGroundDancingImageView.frame = CGRect(x: 150, y: 200, width: 100, height: 100)
        backGroundDancingImageView.contentMode = .scaleAspectFit // 画像のアスペクト比を保持
        backGroundDancingImageView.tintColor = .black
        if let image = UIImage(named: "entakun") { // アセットから画像を読み込む
            dancingImageView.image = image
            backGroundDancingImageView.image = image
            backGroundDancingImageView.image = image.withRenderingMode(.alwaysTemplate)

        }
        view.addSubview(backGroundDancingImageView)
        view.addSubview(dancingImageView)
        

        animateDance()
        animateCircularMotion()
    }

    func animateDance() {
        // キーフレームアニメーションオブジェクトを作成
        let danceAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")

        // アニメーションのキーフレームを定義
        danceAnimation.values = [0, 0.1, 0, -0.1, 0] // 左右に振る
        danceAnimation.duration = 0.1 // 0.6秒間
        danceAnimation.repeatCount = Float.infinity // 無限に繰り返す

        // アニメーションをUIImageViewのレイヤーに追加
        dancingImageView.layer.add(danceAnimation, forKey: "dancing")
    }

    func animateCircularMotion() {
        // 円運動のパスを作成
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 200, y: 250), radius: 5, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

        // 円運動のアニメーション
        let circularMotion = CAKeyframeAnimation(keyPath: "position")
        circularMotion.path = circularPath.cgPath
        circularMotion.duration = 0.7
        circularMotion.repeatCount = .infinity
        circularMotion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        // アニメーションを背景のUIImageViewのレイヤーに追加
        backGroundDancingImageView.layer.add(circularMotion, forKey: "circularMotion")
    }
}
#Preview {
    let viewController = CoreAnimationViewController()
    return viewController
}
