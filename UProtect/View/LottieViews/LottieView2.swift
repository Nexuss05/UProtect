//
//  LottieView2.swift
//  UProtect
//
//  Created by Andrea Romano on 27/05/24.
//

import SwiftUI
import Lottie

struct Lotties: UIViewRepresentable {
    let loopmode: LottieLoopMode
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        
        let animationView = LottieAnimationView(name: "Animation - 1716803277345")
        animationView.play()
        animationView.loopMode = loopmode
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
    }
}
