//
//  BlurVisualEffectViewRepresentable.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 23/02/2025.
//

import SwiftUI
import UIKit

struct _BlurVisualEffectViewRepresentable: UIViewRepresentable {
    let style: UIBlurEffect.Style
    let cornerRadius: CGFloat
    
    init(style: UIBlurEffect.Style = .dark, cornerRadius: CGFloat = 32) {
        self.style = style
        self.cornerRadius = cornerRadius
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffectView.removeFromSuperview()
        blurEffectView.layer.cornerRadius = cornerRadius
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
