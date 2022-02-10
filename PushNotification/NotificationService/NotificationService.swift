//
//  NotificationService.swift
//  NotificationService
//
//  Created by Codexprt on 08/02/22.
//

import UserNotifications
import UIKit


class NotificationService: UNNotificationServiceExtension {

    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var serviceManager = ServiceManager()

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let userDefaults = UserDefaults(suiteName: "group.centigram.io") {
            userDefaults.set("My Data" as AnyObject, forKey: "key1")
            userDefaults.synchronize()
        }
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
        
            let str = bestAttemptContent.title
//            serviceManager.getRequest(url: "register?msg=Datacall") { response , error in
//                print(response ?? "")
//                print(error ?? "")
//                print(response?["data"])
//              }
            
            if let userDefaults = UserDefaults(suiteName: "group.centigram.io") {
                userDefaults.set(bestAttemptContent.title as AnyObject, forKey: "key1")
                userDefaults.synchronize()
            }
            contentHandler(bestAttemptContent)
        }
}
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
