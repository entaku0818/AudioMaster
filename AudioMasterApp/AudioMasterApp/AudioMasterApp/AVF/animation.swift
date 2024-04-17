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
        // 回転アニメーションオブジェクトを作成
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.values = [0, 0.05, 0, -0.05, 0] // 左右に振る
        rotationAnimation.duration = 0.15
        rotationAnimation.repeatCount = Float.infinity

        // 上下移動のアニメーションオブジェクトを作成
        let verticalAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        verticalAnimation.values = [0, -1, 0, 1, 0] // 上下に振る
        verticalAnimation.duration = 0.2
        verticalAnimation.repeatCount = Float.infinity

        // アニメーショングループを作成し、UIImageViewのレイヤーに追加
        let group = CAAnimationGroup()
        group.animations = [rotationAnimation, verticalAnimation]
        group.duration = 0.6
        group.repeatCount = Float.infinity
        dancingImageView.layer.add(group, forKey: "dancing")
    }


    func animateCircularMotion() {
        // 円運動のパスを作成（反時計回りに設定）
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 200, y: 250), radius: 3, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)

        // 円運動のアニメーション
        let circularMotion = CAKeyframeAnimation(keyPath: "position")
        circularMotion.path = circularPath.cgPath
        circularMotion.duration = 0.6
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
