//
//  UIPageControl+extensions.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 30.01.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import UIKit
extension UIPageControl {

    func customPageControl(shadowColor: UIColor = UIColor.black, shadowOpacity: Float = 1, shadowRadius: CGFloat = 1) {
        for (_, dotView) in self.subviews.enumerated() {
            dotView.layer.shadowColor = shadowColor.cgColor
            dotView.layer.shadowOpacity = shadowOpacity
            dotView.layer.shadowOffset = .zero
            dotView.layer.shadowRadius = shadowRadius
        }
    }

}
