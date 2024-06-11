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
        deleteOldRecordings()
    }
    
    private func deleteOldRecordings() {
        let now = Date()
        let oneWeekAgo = now.addingTimeInterval(-10080 * 60) // 1 week ago
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
                        UProtect(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
//            ContentView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
            //            Newbutton(timerManager: timerManager, audioRecorder: audioRecorder)
//                        RegistrationView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
            //            WelcomeView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                .onAppear{
                    vm.fetchUserPosition()
                    vm.fetchFriend()
                }
                .preferredColorScheme(theme == "" ? .none : theme == "dark" ? .dark : .light)
            //                .onOpenURL { url in
            //                    guard
            //                        let scheme = url.scheme,
            //                        let host = url.host else {
            //                        // Invalid URL format
            //                        return
            //                    }
            //
            //                    guard scheme == "widget" else {
            //                        // The deep link is not trigger by widget
            //                        return
            //                    }
            //
            //                    switch host {
            //                    case "sos":
            //                        timerManager.Activation()
            //                    default:
            //                        break
            //                    }
            //                }
        }.modelContainer(sharedModelContainer)
            .environment(locationManager)
            .onChange(of: scene) { newScenePhase in
                if newScenePhase == .active {
                    deleteOldRecordings()
                }
            }
    }
    
    //    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //        if url.scheme == "widget://sos" {
    //            // Attiva l'SOS button
    //            timerManager.Activation()
    //            return true
    //        }
    //        return false
    //    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Request permission for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied: \(error?.localizedDescription ?? "")")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Inoltra le notifiche remote a FIRAuth
        Auth.auth().canHandleNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(tokenString)")
        UserDefaults.standard.set(tokenString, forKey: "fcmToken")
        FirebaseApp.configure()
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
    
    // Handle notification when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func registerForRemoteNotifications() {
        // Richiedi il permesso per le notifiche remote
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
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                print("Notification permission granted")
//            } else {
//                print("Notification permission denied: \(error?.localizedDescription ?? "")")
//            }
//        }
//        UNUserNotificationCenter.current().delegate = self
//        application.registerForRemoteNotifications()
////        FirebaseApp.configure()
//        return true
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register for remote notifications: \(error.localizedDescription)")
//    }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        print("Device Token: \(tokenString)")
//        UserDefaults.standard.set(tokenString, forKey: "fcmToken")
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // Inoltra le notifiche remote a FIRAuth
//        Auth.auth().canHandleNotification(userInfo)
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        if Auth.auth().canHandleNotification(userInfo) {
//            completionHandler(.noData)
//            return
//        }
//    }
//
//    // Handle notification when the app is in the foreground
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .sound, .badge])
//    }
//
//    func registerForRemoteNotifications() {
//        // Request permission for remote notifications
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
//            if granted {
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            } else {
//                print("Permission denied for remote notifications")
//            }
//        }
//    }
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//}

