//
//  VolumeVisualizerView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/02/23.
//

import Foundation
import UIKit

class VolumeVisualizerView: UIView {
    private var barViews: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBars()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBars()
    }

    private func setupBars() {
        let barCount = 3
        let spacing: CGFloat = 2
        let barWidth = (self.bounds.width - spacing * CGFloat(barCount - 1)) / CGFloat(barCount)

        for i in 0..<barCount {
            let barView = UIView(frame: CGRect(x: (barWidth + spacing) * CGFloat(i), y: 0, width: barWidth, height: self.bounds.height))
            barView.backgroundColor = .gray
            self.addSubview(barView)
            barViews.append(barView)
        }
    }

    func updateVolume(_ volume: [CGFloat]) {
        for (index, barView) in barViews.enumerated() {
            let height = volume[index] * self.bounds.height
            let yPosition = self.bounds.height - height
            UIView.animate(withDuration: 0.1) {
                barView.frame = CGRect(x: barView.frame.origin.x, y: yPosition, width: barView.frame.width, height: height)
            }
        }
    }
}
