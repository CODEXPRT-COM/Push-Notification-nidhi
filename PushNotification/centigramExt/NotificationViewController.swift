//
//  NotificationViewController.swift
//  centigramExt
//
//  Created by Codexprt on 07/02/22.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var dataImg: UIImageView!
    
    var serviceManager = ServiceManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.handleNotifData()
    }

    func handleNotifData() {
        let pref = UserDefaults.init(suiteName: "group.centigram.io")
        let notifData = pref?.object(forKey: "NOTIF_DATA") as? NSDictionary
        let aps = notifData?["aps"] as? NSDictionary
        let alert = aps?["alert"] as? NSDictionary
        let body = alert?["body"] as? String
        
        self.dataLbl.text = "\(body ?? "-")"
        // Getting image from UNNotificationAttachment
        guard let imageData = pref?.object(forKey: "NOTIF_IMAGE") else { return }
        guard let data = imageData as? Data else { return }
        self.dataImg.image = UIImage(data: data)
    }
    
    @objc func becomeActive() {
        self.handleNotifData()
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        serviceManager.getRequest(url: "register?msg=NotificationExtent") { response , error in
            print(response ?? "")
            print(error ?? "")
            print(response?["data"])
          }
        if let userDefaults = UserDefaults(suiteName: "group.centigram.io") {
            userDefaults.set(self.label?.text as AnyObject, forKey: "key1")
            userDefaults.synchronize()
        }
        
    }
  
}
extension NotificationViewController : UNNotificationContentExtension{
    
 func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void)
    {
        if let textResponse = response as? UNTextInputNotificationResponse, let txt = textResponse.userText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    serviceManager.getRequest(url: "register?msg=\(txt)") { response , error in
                        print(response ?? "")
                        print(error ?? "")
                        print(response?["data"])
                        completion(.dismiss)

                    }
                }
    }
}
