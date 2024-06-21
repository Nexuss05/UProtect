import SwiftUI
import UserNotifications
import CoreLocation

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
                
                FifthPageView()
                    .tag(4)
                    .overlay(
                        ZStack {
                            if !checkWelcomeScreen{
                                if UserDefaults.standard.integer(forKey: "NotificationAuth") == 1 && UserDefaults.standard.integer(forKey: "LocationAuth") == 1 {
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
                                            .foregroundColor(CustomColor.ocra)
                                            .frame(width: 200, height: 60)
                                    )
                                } else {
                                    Text("Get started")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundColor(.gray)
                                                .frame(width: 200, height: 60)
                                            )
                                }
                            }
                        }.padding(.top, 550)
                    )
            }
            .ignoresSafeArea()
            .animation(.easeInOut, value: pageIndex)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                CustomPageControl(currentPage: $pageIndex, numberOfPages: 5)
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
                Rectangle()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 270, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .opacity(0)
                Text("SOS mode")
                    .font(.title)
                    .bold()
                    .frame(width: 340)
                
                Text("Notify your emergency contacts and record your background by clicking the Panic Button. If they have the app, they will receive a push notification with your shared location. Otherwise they will receive an SMS.")
                    .fontWeight(.light)
                    .frame(width: 310)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }
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
            VStack{
                Rectangle()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 270, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .opacity(0)
                Text("Supervision mode")
                    .font(.title)
                    .bold()
                    .frame(width: 340)
                
                Text("If you feel unsafe but not so much to notify your contacts, hold the Panic Button and start the customisable timer. If you don’t dismiss the alert on timer ending or if you don’t answer, a notification will be sent.")
                    .fontWeight(.light)
                    .frame(width: 310)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }
        }
        .onReceive(self.time) { _ in
            DispatchQueue.main.async {
                if self.vm.isTimerRunning {
                    if self.count > 180 {
                        self.count -= 1
//                        print("\(self.count)")
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
            VStack{
                Rectangle()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 270, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .opacity(0)
                if Locale.current.language.languageCode?.identifier == "it" {
                    Text("Mappa")
                        .font(.title)
                        .bold()
                        .frame(width: 340)
                
                    Text("Grazie alla mappa puoi facilmente dare un'occhiata a negozi e locali aperti vicino a te. Se hai bisogno di cercare rifugio, puoi chiamare il posto o camminare lì grazie alla mappa.\n")
                        .fontWeight(.light)
                        .frame(width: 310)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                } else {
                    Text("Map")
                        .font(.title)
                        .bold()
                        .frame(width: 340)
                
                    Text("Thanks to the map you can easily have a look at shops and stores open nearby you. If you need to seek shelter, you can call the place or walk there thanks to the map.\n")
                        .fontWeight(.light)
                        .frame(width: 310)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                }
            }
        }.onAppear{
            let languageCode = Locale.current.language.languageCode?.identifier
                    print("Current language code: \(languageCode ?? "unknown")")
        }
    }
}

struct FourthPageView: View {
    
    var body: some View {
        ZStack {
            Image("p5")
            VStack{
                Rectangle()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 270, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .opacity(0)
                if Locale.current.language.languageCode!.identifier == "it" {
                    Text("Consigli")
                        .font(.title)
                        .bold()
                        .frame(width: 340)
                    
                    Text("Questa sezione offre un potente archivio di conoscenze, con suggerimenti e trucchi per mitigare e gestire meglio le situazioni pericolose.\n\n")
                        .fontWeight(.light)
                        .frame(width: 310)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                } else {
                    Text("Tips & Tricks")
                        .font(.title)
                        .bold()
                        .frame(width: 340)
                    
                    Text("This section offers you a powerful knowledge repository, with tips and tricks to better mitigate and manage dangerous situations.\n\n")
                        .fontWeight(.light)
                        .frame(width: 310)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                }
            }
        }
    }
}

struct FifthPageView: View {
    @State var isAuthorized = false
    @State var isAccepted = false
    @State var tapped = false
    
    @State var isAuthorized2 = false
    @State var isAccepted2 = false
    @State var tapped2 = false
    
    @State var locationManager = LocationManager.shared
    
    var body: some View {
        ZStack {
            Image("p3")
            VStack{
                Rectangle()
                    .frame(width: 100, height: 210, alignment: .center)
                    .opacity(0)
                Text("Enable Services")
                    .font(.title)
                    .bold()
                    .frame(width: 340)
                    .padding(.bottom, 35)
                    .padding(.top, 10)
                
//                Text("In order to give you the best experience possible, we will need the authorization for different services\n\n\n")
//                    .fontWeight(.light)
//                    .frame(width: 310)
//                    .multilineTextAlignment(.center)
//                    .padding(.vertical)
                
                VStack(spacing: 25){
                    HStack(){
                        Text("Allow Notification")
                            .fontWeight(.medium)
                        Spacer()
                        Button(action: {
                            askForPermission() {
                                checkPermission()
                            }
                            UserDefaults.standard.set(1, forKey: "NotificationAuth")
                        }, label: {
                            if !isAuthorized {
                                if !tapped {
                                    Image(systemName: "circle")
                                        .tint(CustomColor.ocra)
                                        .font(.system(size: 25))
                                }
                                if !isAccepted && tapped {
                                    Image(systemName: "xmark.circle.fill")
                                        .tint(CustomColor.redBackground)
                                        .font(.system(size: 25))
                                }
                            } else {
                                if !isAccepted {
                                    Image(systemName: "xmark.circle.fill")
                                        .tint(CustomColor.redBackground)
                                        .font(.system(size: 25))
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .tint(CustomColor.ocra)
                                        .font(.system(size: 25))
                                }
                            }
                        })
                    }.frame(width: 290)
                    
                    HStack(){
                        Text("Allow Location")
                            .fontWeight(.medium)
                        Spacer()
                        Button(action: {
                            locationManager.request()
                            UserDefaults.standard.set(1, forKey: "LocationAuth")
                        }, label: {
                            if !locationManager.isAuthorized {
                                if !locationManager.tapped {
                                    Image(systemName: "circle")
                                        .tint(CustomColor.ocra)
                                    .font(.system(size: 25))                                }
                                if !locationManager.isAuthorized && locationManager.tapped {
                                    Image(systemName: "xmark.circle.fill")
                                        .tint(CustomColor.redBackground)
                                        .font(.system(size: 25))
                                }
                            } else {
                                if !locationManager.isAccepted{
                                    Image(systemName: "xmark.circle.fill")
                                        .tint(CustomColor.redBackground)
                                        .font(.system(size: 25))
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .tint(CustomColor.ocra)
                                        .font(.system(size: 25))
                                }
                            }
                        })
                    }.frame(width: 290)
                }
            }
        }
    }
    
    func askForPermission(completion: @escaping () -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                isAuthorized = true
                print("Notification permission granted")
                completion()
            } else {
                isAuthorized = false
                print("Notification permission denied: \(error?.localizedDescription ?? "")")
                completion()
            }
        }
    }
    
    func checkPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                isAccepted = false
                print("1")
            case .denied:
                isAccepted = false
                tapped = true
                print("2")
            case .authorized:
                isAccepted = true
                print("3")
            default:
                print("Unknown notification authorization status")
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeView(timerManager: TimerManager(), audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
                .environment(\.locale, .init(identifier: "en"))

            WelcomeView(timerManager: TimerManager(), audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
                .environment(\.locale, .init(identifier: "it"))
        }
    }
}

