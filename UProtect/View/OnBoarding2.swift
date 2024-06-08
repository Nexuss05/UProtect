//
//  OnBoarding2.swift
//  UProtect
//
//  Created by Simone Sarnataro on 06/06/24.
//

import SwiftUI

struct OnBoarding2: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = AnimationViewModel()
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer: AudioPlayer
    
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var checkWelcomeScreen: Bool = false
    
    @State var showLogin = false
    @State private var pageIndex = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $pageIndex) {
                FirstPageView(viewModel: viewModel)
                    .tag(0)
                
                SecondPageView(vm: viewModel)
                    .tag(1)
                
                ThirdPageView()
                    .tag(2)
                
                FourthPageView()
                    .tag(3)
                    .overlay{
                        ZStack(alignment: .center){
                            Text("- Made by Eleonora Iannelli, Andrea Romano, Alessia Previdente, Yuri Mario Gianoli, Simone Sarnataro, Matteo Cotena")
                                .font(.caption2)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .frame(width: 300)
                        }.padding(.top, 550)
                    }
            }
            .ignoresSafeArea()
            .animation(.easeInOut, value: pageIndex)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                CustomPageControl(currentPage: $pageIndex, numberOfPages: 4)
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                //                    .padding(.bottom, 95)
            }
        }
        .onAppear {
            let dotAppearance = UIPageControl.appearance()
            dotAppearance.currentPageIndicatorTintColor = .red
            dotAppearance.pageIndicatorTintColor = .gray
            checkWelcomeScreen = isWelcomeScreenOver
        }
        .fullScreenCover(isPresented: $showLogin, content: {
            RegistrationView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
        })
    }
}

struct WelcomeView_Previews2: PreviewProvider {
    static var previews: some View {
        WelcomeView(timerManager: TimerManager(), audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
    }
}
