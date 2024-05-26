import SwiftUI

class AnimationViewModel: ObservableObject {
    @Published var showCircle: Bool = false
    
    init() {
        startAnimation()
    }
    
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            withAnimation {
                self.showCircle.toggle()
            }
        }
    }
}

struct WelcomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = AnimationViewModel()
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    
    @State var showLogin = false
    @State private var pageIndex = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $pageIndex) {
                FirstPageView(viewModel: viewModel)
                    .tag(0)
                
                SecondPageView()
                    .tag(1)
                
                ThirdPageView()
                    .tag(2)
                
                FourthPageView()
                    .tag(3)
                    .overlay(
                        ZStack {
                            Button(action: {
                                   showLogin = true
                                }) {
                                    Text("Get started")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(CustomColor.redBackground)
                                        .frame(width: 200, height: 60)
                                )
                        }.padding(.top, 630)
                    )
            }
            .ignoresSafeArea()
            .animation(.easeInOut, value: pageIndex)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                CustomPageControl(currentPage: $pageIndex, numberOfPages: 4)
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    .padding(.bottom, 95)  // Adjust the padding as needed
            }
        }
        .onAppear {
            let dotAppearance = UIPageControl.appearance()
            dotAppearance.currentPageIndicatorTintColor = .red
            dotAppearance.pageIndicatorTintColor = .gray
        }
        .fullScreenCover(isPresented: $showLogin, content: {
            RegistrationView(timerManager: timerManager, audioRecorder: audioRecorder)
        })
    }
}

struct FirstPageView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: AnimationViewModel // New line
    
    var body: some View {
        VStack {
            ZStack{
                Image("s1")
                    .resizable()
                    .frame()
                Circle()
                    .foregroundColor(.white)
                    .opacity(viewModel.showCircle ? 0.3 : 0)
                    .frame(width: viewModel.showCircle ? 270 : 170)
                Circle()
                    .foregroundColor(.white)
                    .opacity(viewModel.showCircle ? 0.3 : 0)
                    .frame(width: viewModel.showCircle ? 220: 170)
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 170, height: 170)
                    .shadow(color: colorScheme == .dark ? .white : .gray, radius: colorScheme == .dark ? 6 : 4)
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 75, height: 70)
                    .foregroundColor(CustomColor.redBackground)
            }
            VStack{
                Text("SOS mode")
                    .font(.title)
                    .bold()
                    .frame(width: 340)
                    .padding(.top, 25)

                Text("Favorite tunes follow, anytime, anywhere.\nWorry-free offline playback for your journey.")
                    .fontWeight(.light)
                    .frame(width: 340)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }
        }.padding(.bottom, 150)
    }
}

struct SecondPageView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            ZStack{
                Image("s2")
                    .resizable()
                    .frame()
//                RingView(percentage: 0.8, backgroundColor: Color.white.opacity(0), startColor: .white, endColor: .white, thickness: 37)
//                    .scaleEffect(0.671)
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 25, lineCap: .round))
                    .frame(width: 214.5, height: 214.5)
                    .rotationEffect(.degrees(0))
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 170, height: 170)
                    .shadow(color: colorScheme == .dark ? .white : .gray, radius: colorScheme == .dark ? 6 : 4)
                Text("4:30")
                    .foregroundStyle(.black)
                    .font(.system(size: 65))
                    .fontWeight(.bold)
            }
            VStack{
                Text("Supervision mode")
                    .font(.title)
                    .bold()
                    .frame(width: 340)
                    .padding(.top, 25)

                Text("Pristine sound quality for absolute\nclarity in audio playback.")
                    .fontWeight(.light)
                    .frame(width: 340)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }
        }.padding(.bottom, 150)
    }
}

struct ThirdPageView: View {
    var body: some View {
        VStack {
            ZStack{
                Image("s3")
                    .resizable()
                    .frame()
            }
            VStack{
                Text("Map")
                    .font(.title)
                    .bold()
                    .frame(width: 340)
                    .padding(.top, 25)

                Text("Curated weekly playlists tailored to\nyour music listening history.")
                    .fontWeight(.light)
                    .frame(width: 340)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }
        }.padding(.bottom, 150)
    }
}

struct FourthPageView: View {
    var body: some View {
        VStack {
            ZStack{
                Image("s4")
                    .resizable()
                    .frame()
            }
            VStack{
                Text("Courses")
                    .font(.title)
                    .bold()
                    .frame(width: 340)
                    .padding(.top, 25)

                Text("Curated weekly playlists tailored to\nyour music listening history.")
                    .fontWeight(.light)
                    .frame(width: 340)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }
        }.padding(.bottom, 150)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(timerManager: TimerManager(), audioRecorder: AudioRecorder())
    }
}
