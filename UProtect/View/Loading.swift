//
//  Loading.swift
//  UProtect
//
//  Created by Matteo Cotena on 05/06/24.
//

import SwiftUI
import Lottie

struct Loading: UIViewRepresentable {
    let loopmode: LottieLoopMode
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        
        let animationView = LottieAnimationView(name: "Animation - 1717609436208")
        animationView.play()
        animationView.loopMode = loopmode
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
    }
}


struct Loading_View: View {
    var body: some View {
        ZStack{
            Loading(loopmode: .loop)
                .scaleEffect(0.60)
                .background(Color.black.opacity(0.3))
        }
    }
}

#Preview {
    Loading_View()
}
