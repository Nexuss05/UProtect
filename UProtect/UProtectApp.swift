//
//  UProtectApp.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth
import Firebase

@main
struct UProtectApp: App {
    @AppStorage("theme") var theme: String = "light"
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var timerManager = TimerManager()
    @StateObject var vm = CloudViewModel()
    @StateObject var audioRecorder = AudioRecorder()
    @StateObject var audioPlayer = AudioPlayer()
    @State private var locationManager = LocationManager()
    
    @Environment (\.scenePhase) var scene
    
    init() {
        UITabBar.setCustomAppearance()
        TimeManager.shared.setupWCSession()
        TimeManager.shared.syncTokens()
        TimeManager.shared.syncName()
        TimeManager.shared.syncSurname()
    }
    
    private func deleteOldRecordings() {
        let now = Date()
        let oneWeekAgo = now.addingTimeInterval(-10080 * 60)
        let recordingsToDelete = audioRecorder.recordings.filter { $0.createdAt < oneWeekAgo }
        let urlsToDelete = recordingsToDelete.map { $0.fileURL }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Counter.self, Contacts.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                .onAppear {
                    vm.fetchUserPosition()
                    vm.fetchFriend()
                    deleteOldRecordings()
                }
                .preferredColorScheme(theme == "" ? .none : theme == "dark" ? .dark : .light)
        }
        .modelContainer(sharedModelContainer)
        .environment(locationManager)
        .onChange(of: scene) { newScenePhase in
            if newScenePhase == .active {
                print("App became active, resetting badge count.")
                deleteOldRecordings()
                vm.resetBadge()
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            if newScenePhase == .inactive {
                vm.fetchBadge(completion: { badge in
                    DispatchQueue.main.async {
                        UIApplication.shared.applicationIconBadgeNumber = badge ?? 1
                    }
                })
            }
            if newScenePhase == .background {
                vm.fetchBadge(completion: { badge in
                    DispatchQueue.main.async {
                        UIApplication.shared.applicationIconBadgeNumber = badge ?? 1
                    }
                })
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var vm = CloudViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied: \(error?.localizedDescription ?? "")")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        vm.fetchBadge(completion: { badge in
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = badge ?? 1
            }
        })
//        if let savedBadgeCount = UserDefaults.standard.object(forKey: "badgeCount") as? Int {
//            
//                UIApplication.shared.applicationIconBadgeNumber = savedBadgeCount
//        }
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        Auth.auth().canHandleNotification(userInfo)
//        incrementBadgeCount()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        
//        incrementBadgeCount()
        completionHandler(.newData)
    }
    
//    private func incrementBadgeCount() {
//        let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
//        let newBadgeCount = currentBadgeCount + 1
//        UserDefaults.standard.set(newBadgeCount, forKey: "badgeCount")
//        UIApplication.shared.applicationIconBadgeNumber = newBadgeCount
//    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(tokenString)")
        UserDefaults.standard.set(tokenString, forKey: "fcmToken")
        FirebaseApp.configure()
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        incrementBadgeCount()
        completionHandler([.banner, .sound, .badge])
    }
    
    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Permission denied for remote notifications")
            }
        }
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("termination process")
        if AudioRecorder.shared.recording {
            AudioRecorder.shared.stopRecording()
        }
        guard let savedTokens = UserDefaults.standard.stringArray(forKey: "tokens") else {
            print("Nessun token salvato in UserDefaults.")
            return
        }

        let dispatchGroup = DispatchGroup()

        for token in savedTokens {
            dispatchGroup.enter()
            print("Processing token: \(token)")
            vm.sendPositionAndInsertName(token: token, latitude: 0, longitude: 0, nomeAmico: "", cognomeAmico: "") {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.wait()
        print("All token processing complete")
    }
}
