//
//  CSegmentedControl.swift
//  UProtect
//
//  Created by Simone Sarnataro on 20/06/24.
//

//import SwiftUI
//
//struct CSegmentedControl<Indicator: View>: View {
//var tabs: [SegmentedTab]
//    @Binding var activeTab: SegmentedTab
//    var height: CGFloat = 45
//    
//    @ViewBuilder var indicatorView: (CGSize) -> Indicator
//    
//    @State var excessTabWidth: CGFloat = .zero
//    @State var minX: CGFloat = .zero
//    
//    var body: some View {
//        GeometryReader{
//            let size = $0.size
//            let conteinerWidth = size.width / CGFloat(tabs.count)
//            
//            HStack(spacing: 0){
//                ForEach(tabs, id: \.rawValue){ tab in
//                    Group{
//                        VStack{
//                            Text(tab.rawValue)
//                                .font(.footnote)
//                            if tabs.first == tab {
//                                GeometryReader{
//                                    let size = $0.size
//                                    indicatorView(size)
//                                        .frame(width: size.width + (excessTabWidth < 0 ? -excessTabWidth : excessTabWidth), height: 2.5)
//                                        .frame(width: size.width, alignment: excessTabWidth < 0 ? .trailing : .leading)
//                                        .offset(x: minX)
//                                }
//                            }
//                        }
//                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .contentShape(.rect)
//                        .animation(.snappy, value: activeTab)
//                        .onTapGesture {
//                            if let index = tabs.firstIndex(of: tab), let activeIndex = tabs.firstIndex(of: activeTab){
//                                activeTab = tab
//                                withAnimation(.snappy(duration: 0.25, extraBounce: 0), completionCriteria: .logicallyComplete) {
//                                    excessTabWidth = conteinerWidth * CGFloat(index - activeIndex)
//                                } completion: {
//                                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)){
//                                        minX = conteinerWidth * CGFloat(index)
//                                        excessTabWidth = 0
//                                    }
//                                }
//                            }
//                        }
//                }
//            }
//        }.frame(height: height)
//    }
//}

import SwiftUI

struct CSegmentedControl<Indicator: View>: View {
    var tabs: [SegmentedTab]
    @Binding var activeTab: SegmentedTab
    var height: CGFloat = 45
    
    @ViewBuilder var indicatorView: (CGSize) -> Indicator
    
    @State private var indicatorOffset: CGFloat = .zero
    @State private var indicatorWidth: CGFloat = .zero
    
    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width / CGFloat(tabs.count)
            
            VStack() {
                HStack(spacing: 0) {
                    ForEach(tabs, id: \.rawValue) { tab in
                        Text(tab.rawValue)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    activeTab = tab
                                }
                            }
                    }
                }
                GeometryReader { proxy in
                    let size = proxy.size
                    indicatorView(size)
                        .frame(width: indicatorWidth, height: 2.5)
                        .offset(x: indicatorOffset)
                        .onChange(of: activeTab) { _ in
                            withAnimation(.snappy) {
                                if let index = tabs.firstIndex(of: activeTab) {
                                    indicatorOffset = containerWidth * CGFloat(index)
                                    indicatorWidth = containerWidth
                                }
                            }
                        }
                }
            }
            .frame(height: height)
        }.frame(height: height)
        .onAppear {
            if let index = tabs.firstIndex(of: activeTab) {
                let containerWidth = UIScreen.main.bounds.width / CGFloat(tabs.count)
                indicatorOffset = containerWidth * CGFloat(index)
                indicatorWidth = containerWidth
            }
        }
    }
}
