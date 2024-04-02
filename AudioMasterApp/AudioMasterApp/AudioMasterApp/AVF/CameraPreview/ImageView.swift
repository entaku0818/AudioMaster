//
//  ImageView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/04/02.
//

import Foundation
import UIKit
import SwiftUI
struct ImageView: View {
    let image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

extension UIImage: Identifiable {
    public var id: UUID {
        UUID()
    }
}
