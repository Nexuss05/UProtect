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

@main
struct UProtectApp: App {
    // Forzato la light mode nell'app
    @AppStorage("theme") var theme: String = "light"
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var timerManager = TimerManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(timerManager: timerManager)
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
        }.modelContainer(for: [Counter.self, Contacts.self])
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
                //                print("Notification permission granted")
            } else {
                //                print("Notification permission denied: \(error?.localizedDescription ?? "")")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //        print("Failed to register for remote notifications: \(error.localizedDescription)")
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
        //        print("Device Token: \(tokenString)")
        UserDefaults.standard.set(tokenString, forKey: "fcmToken")
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
                //                    print("Permission denied for remote notifications")
            }
        }
    }
    
}

