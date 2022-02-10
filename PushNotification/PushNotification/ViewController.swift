//
//  ViewController.swift
//  PushNotification
//
//  Created by Codexprt on 07/02/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var dataImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
}

