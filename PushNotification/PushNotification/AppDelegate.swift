//
//  AppDelegate.swift
//  PushNotification
//
//  Created by Codexprt on 07/02/22.
//

import UIKit
import CoreData
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var serviceManager = ServiceManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            register()
      //  showPushButtons()
        
        print("MyData : -- %@",UserDefaults.standard.string(forKey: "myData"))
        
        if let userDefaults = UserDefaults(suiteName: "group.centigram.io") {
            let value1 = userDefaults.string(forKey: "key1")
            print("Data Display :- ", value1)
        }
        // Override point for customization after application launch.
        return true
    }

    func register(){
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in
                let replyAction = UNTextInputNotificationAction(identifier: "ReplyAction", title: "Reply", options: [])
                let openAppAction = UNNotificationAction(identifier: "OpenAppAction", title: "Open app", options: [.foreground])
                let quickReplyCategory = UNNotificationCategory(identifier: "QuickReply", actions: [replyAction, openAppAction], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([quickReplyCategory])
                
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                    guard settings.authorizationStatus == .authorized else { return }
                   // UIApplication.shared.registerForRemoteNotifications()
                }

            })
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    // MARK: UISceneSession Lifecycle

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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PushNotification")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate : UNUserNotificationCenterDelegate{
  
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("My Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error registering notifications: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
   {
         // Save pushnotification data to core data
       print("Recive Data %@",userInfo)
   }

    // Receive displayed notifications for iOS 10 or later devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Receive notification in the foreground \(userInfo)")
        let pref = UserDefaults.init(suiteName: "group.centigram.io")
        pref?.set(userInfo, forKey: "NOTIF_DATA")
        guard let vc = UIApplication.shared.windows.first?.rootViewController as? ViewController else { return }
        vc.handleNotifData()
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "ReplyAction" {
                if let textResponse = response as? UNTextInputNotificationResponse {
                    // Do whatever you like with user text response...
                   // completion(.doNotDismiss)
                    
                    print("text Response %@",textResponse.userText)
                    UserDefaults.standard.set(textResponse.userText, forKey: "myData")
                    
                    let userInfo = response.notification.request.content.userInfo
                    // Print full message.
                    print("Tap Receive notif Data  :---- \(userInfo)")
                    
                    return
                }
            }
           // completion(.dismiss)
        completionHandler()
    }
    
    func showPushButtons(){
        let replyAction = UNTextInputNotificationAction(
            identifier: "reply.action",
            title: "Reply on message",
            textInputButtonTitle: "Send",
            textInputPlaceholder: "Input text here")

        let pushNotificationButtons = UNNotificationCategory(
            identifier: "allreply.action",
            actions: [replyAction],
            intentIdentifiers: [],
            options: [])

        UNUserNotificationCenter.current().setNotificationCategories([pushNotificationButtons])
    }
}
