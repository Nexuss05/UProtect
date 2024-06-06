import SwiftUI

class AnimationViewModel: ObservableObject {
    @Published var showCircle: Bool = false
    @Published var isTimerRunning = true
    
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
                    .overlay(
                        ZStack {
                            if !checkWelcomeScreen{
                                Button(action: {
                                    showLogin = true
                                    viewModel.isTimerRunning = false
                                }) {
                                    Text("Get started")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(CustomColor.orange)
                                        .frame(width: 200, height: 60)
                                )
                            }
                        }
                            .padding(.top, 550)
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

struct FirstPageView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: AnimationViewModel
    
    var body: some View {
        ZStack {
            Image("E1")
            VStack {
                ZStack{
                    Circle()
                        .frame(width: 415, height: 450)
                        .opacity(0)
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
                }.scaleEffect(CGSize(width: 0.9, height: 0.9))
//                Spacer()
                    .padding(.bottom, 350)
            }
            VStack{
                Text("SOS mode")
                    .font(.title)
                    .bold()
                    .frame(width: 340)
                    .padding(.top, 25)
                
                Text("If you feel in danger after clicking the button, it is possible to notify your emergency contacts by including their phone numbers to seek assistance. If your contacts have installed the application, they will receive a push notification along with your shared location. Otherwise, they will receive an SMS. Until the button is activated, your background will be recorded.")
                    .fontWeight(.light)
                    .frame(width: 340)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }.padding(.top, 300)
        }
    }
}

struct SecondPageView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: AnimationViewModel
    
    @State var to : CGFloat = 0
    @State var count = 300
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var dismissTimer: Timer?
    
    var formattedTime: String {
        let minutes = count / 60
        let seconds = count % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var rotationAngle: Angle {
        let progress = 1 - to
        return .degrees(Double(progress) * 360 - 90)
    }
    
    var body: some View {
        ZStack {
            Image("E4")
            VStack {
                ZStack{
                    Circle()
                        .trim(from: 0, to: to)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 25, lineCap: .round))
                        .frame(width: 214.5, height: 214.5)
                        .rotationEffect(rotationAngle)
                        .onReceive(self.time) { _ in
                            self.to = CGFloat(self.count) / 300
                        }
                    Circle()
                        .trim(from: 0, to: 0.75)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 25, lineCap: .round))
                        .frame(width: 214.5, height: 214.5)
                        .rotationEffect(.degrees(0))
                    Circle()
                        .frame(width: 415, height: 450)
                        .opacity(0)
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 170, height: 170)
                        .shadow(color: colorScheme == .dark ? .white : .gray, radius: colorScheme == .dark ? 6 : 4)
                    Text("\(formattedTime)")
                        .foregroundStyle(.black)
                        .font(.system(size: 65))
                        .fontWeight(.bold)
                }.scaleEffect(CGSize(width: 0.9, height: 0.9))
//                Spacer()
                    .padding(.bottom, 350)
            }
            
            VStack(alignment: .center){
                Text("Supervision mode")
                    .font(.title)
                    .bold()
                    .frame(width: 340)
                    .padding(.top, 25)
                
                Text("If you are feeling unsafe and don't want to notify your contact immediately, simply hold the button to activate the timer. You have the option to modify the timer in the settings to your liking. \nIf you don't dismiss the alert when the time runs out, a notification will be sent.")
                    .fontWeight(.light)
                    .frame(width: 340)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }.padding(.top, 255)
        }.onReceive(self.time) { _ in
            DispatchQueue.main.async {
                if self.vm.isTimerRunning {
                    if self.count > 180 {
                        self.count -= 1
                        print("\(self.count)")
                    } else {
                        self.count = 300
                    }
                } else {
                    self.count = 300
                }
            }
        }
    }
}

struct ThirdPageView: View {
    
    var body: some View {
        ZStack {
            Image("E2")
            VStack {
                Text("Map")
                    .font(.title)
                    .bold()
                    .frame(width: 340)
                    .padding(.top, 25)
                Text("Thanks to the map you can easily have a look at shops and store open nearby you. In case you need a place to go or seek shelter, you can either call the place or have the route highlighted in the map itself.")
                    .fontWeight(.light)
                    .frame(width: 340)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }.padding(.top, 210)
        }
    }
}

struct FourthPageView: View {
    
    var body: some View {
        ZStack {
            Image("E5")
                VStack{
                    Text("Courses")
                        .font(.title)
                        .bold()
                        .frame(width: 340)
                        .padding(.top, 25)
                    Text("This section offers you a powerful tool to gain knowledge, tips and trick and tools to better mitigate dangerouse situations or understeand how to better manage them.")
                        .fontWeight(.light)
                        .frame(width: 340)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                }.padding(.top, 190)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(timerManager: TimerManager(), audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
    }
}
