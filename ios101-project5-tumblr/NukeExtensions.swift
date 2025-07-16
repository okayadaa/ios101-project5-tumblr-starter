//
//  NukeExtensions.swift
//  ios101-project5-tumblr
//
//  Created by Ada Muniz on 7/15/25.
//

import UIKit
import NukeExtensions

enum NukeHelp {
    @MainActor static func loadImage(with urlString: String, into imageView: UIImageView){
        guard let url = URL(string: urlString) else {
            imageView.image = nil
            return
        }
        NukeExtensions.loadImage(with: url, into: imageView)
    }
}
