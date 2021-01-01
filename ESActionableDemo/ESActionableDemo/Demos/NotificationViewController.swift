//
//  NotificationViewController.swift
//  ESActionsDemo
//
//  Created by 罗树新 on 2020/12/29.
//

import UIKit
import ESActionable

extension Notification.Name {
    fileprivate static var notification1: NSNotification.Name = NSNotification.Name("notification1")
    fileprivate static var notification2: NSNotification.Name = NSNotification.Name("notification2")
    fileprivate static var notification3: NSNotification.Name = NSNotification.Name("notification3")
}
class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addObserver1(_ sender: UIButton) {
        observe(.notification1) { [unowned self] (notification) in
            print("name: \(Notification.Name.notification1.rawValue), notification: \(notification)")
            self.showAlert("name: \(Notification.Name.notification1.rawValue), notification: \(notification)")

        }
        showAlert("添加 notification1 observer 成功")
    }
    
    @IBAction func removeObserver1(_ sender: UIButton) {
        unobserve(.notification1)
        showAlert("remove notification1 observer 成功")
    }
    
    @IBAction func addObserver2(_ sender: UIButton) {
        observe(.notification2) { [unowned self] (notification) in
            print("name: \(Notification.Name.notification2.rawValue), notification: \(notification)")
            self.showAlert("name: \(Notification.Name.notification2.rawValue), notification: \(notification)")

        }
        showAlert("添加 notification2 observer 成功")
    }
    
    @IBAction func removeObserver2(_ sender: UIButton) {
        unobserve(.notification2)
        showAlert("remove notification2 observer 成功")
    }
    
    @IBAction func addObserver3(_ sender: UIButton) {
        model.observe(.notification3) { [unowned self] (notification) in
            print("name: \(Notification.Name.notification3.rawValue), notification: \(notification)")
            self.showAlert("name: \(Notification.Name.notification3.rawValue), notification: \(notification)")
        }
        showAlert("\(sender) 添加 notification3 observer 成功")

    }
    
    @IBAction func removeObserver3(_ sender: UIButton) {
        model.unobserve(.notification3)
        showAlert("\(sender) remove notification3 observer 成功")
    }
    
    @IBAction func postNotification(_ sender: UIButton) {
        post(.notification1)
        post(.notification2)
        post(.notification3)
    }
    
    lazy var model: NSObject = {
       let model = NSObject()
        return model
    }()
    
    deinit {
        print("\(self) deinit")
    }
    
    
}
