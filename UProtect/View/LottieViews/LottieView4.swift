//
//  LottieView4.swift
//  UProtect
//
//  Created by Andrea Romano on 27/05/24.
//

import SwiftUI
import Lottie

struct Lottiesss: UIViewRepresentable {
    let loopmode: LottieLoopMode
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        
        let animationView = LottieAnimationView(name: "Animation - 1716804413916")
        animationView.play()
        animationView.loopMode = loopmode
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
    }
}

struct LottieTick: UIViewRepresentable {
    let loopmode: LottieLoopMode
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        
        let animationView = LottieAnimationView(name: "Animation - 1718453926395")
        animationView.play()
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
    }
}



