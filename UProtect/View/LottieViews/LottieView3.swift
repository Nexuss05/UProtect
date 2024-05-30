//
//  LottieView3.swift
//  UProtect
//
//  Created by Andrea Romano on 27/05/24.
//

import SwiftUI
import Lottie

struct Lottiess: UIViewRepresentable {
    let loopmode: LottieLoopMode
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        
        let animationView = LottieAnimationView(name: "Animation - 1716803884547")
        animationView.play()
        animationView.loopMode = loopmode
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
    }
}
