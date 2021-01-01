//
//  ViewController.swift
//  ESActionsDemo
//
//  Created by 罗树新 on 2020/12/28.
//

import UIKit
import ESActionable

extension NSNotification.Name {
    fileprivate static var notification1: NSNotification.Name { return NSNotification.Name("notification1") }
    fileprivate static var notification2: NSNotification.Name { return NSNotification.Name("notification2") }
    fileprivate static var notification3: NSNotification.Name { return NSNotification.Name("notification3") }
}

class ViewController: UIViewController {

 
    
    var notificationAction1: Actionable?
    var notificationAction2: Actionable?
    var notificationAction3: Actionable?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


    @IBAction func notificationActionTest(_ sender: UIButton) {
        let notificationTestVC = NotificationViewController()
        navigationController?.pushViewController(notificationTestVC, animated: true)
    }
    @IBAction func controlActionTest(_ sender: UIButton) {
        let controlActionTestVC = ControlActionTestViewController()
        navigationController?.pushViewController(controlActionTestVC, animated: true)
    }
    @IBAction func gestureRecognizerTest(_ sender: UIButton) {
        let gestureRecognizerTestVC = GestureRecognizerTestViewController()
        navigationController?.pushViewController(gestureRecognizerTestVC, animated: true)
    }
    @IBAction func barButtonItemTest(_ sender: UIButton) {
        let barButtonItemTestVC = BarButtonItemTestViewController()
        navigationController?.pushViewController(barButtonItemTestVC, animated: true)
    }
    @IBAction func keyboardTest(_ sender: UIButton) {
        let keyboardTestVC = KeyboardObserveTestViewController()
        navigationController?.pushViewController(keyboardTestVC, animated: true)
    }
}

