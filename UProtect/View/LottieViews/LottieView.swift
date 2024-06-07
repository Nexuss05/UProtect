//
//  LottieView.swift
//  UProtect
//
//  Created by Andrea Romano on 26/05/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let loopmode: LottieLoopMode
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        
        let animationView = LottieAnimationView(name: "Animation - 1717796203824")
        animationView.play()
        animationView.loopMode = loopmode
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
    }
}
