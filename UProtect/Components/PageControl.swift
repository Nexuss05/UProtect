//
//  PageControl.swift
//  UProtect
//
//  Created by Simone Sarnataro on 24/05/24.
//

import SwiftUI

struct CustomPageControl: UIViewRepresentable {
    @Binding var currentPage: Int
    var numberOfPages: Int

    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .gray
        return pageControl
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
}
