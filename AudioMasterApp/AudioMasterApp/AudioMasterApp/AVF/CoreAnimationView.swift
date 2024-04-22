//
//  CoreAnimationView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/04/22.
//

import SwiftUI
import UIKit

struct CoreAnimationView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CoreAnimationViewController {
        CoreAnimationViewController()
    }

    func updateUIViewController(_ uiViewController: CoreAnimationViewController, context: Context) {
    }
}

struct CoreAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CoreAnimationView()
    }
}
