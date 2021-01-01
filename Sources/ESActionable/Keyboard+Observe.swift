//
//  Keyboard+Observe.swift
//  ESActionable
//
//  Created by 罗树新 on 2020/12/31.
//

import UIKit

/// Keyboard Notification info
public class KeyboardActionInfo {
    
    /// Keyboard animation options
    public var animationCure: UIView.AnimationOptions?
    
    /// Keyboard animation duration
    public var animationDuration: TimeInterval = 0.0
    
    /// Keyboard frame of animation begin
    public var beginFrame: CGRect?
    
    /// Keyboard frame of animation end
    public var endFrame: CGRect?
    
    public var isLocal: Bool = false
    
}

public extension NSObject {
    
    /// The action executed when the keyboard will show. Object observes the keyboard notification and executes the action when it receives the notification that the keyboard will show
    /// - Parameter action: The action will be executed when the object receives the notification named `keyboardWillShowNotification`
    func keyboardWillShow(action: @escaping (KeyboardActionInfo) -> ()) {
        observe(UIApplication.keyboardWillShowNotification) { [unowned self] (notification) in
            let info = self.info(for: notification)
            action(info)
        }
    }
    
    /// The action executed when the keyboard will hide. Object observes the  notification named `keyboardWillHideNotification` and executes the action when it receives the notification that the keyboard will hide
    /// - Parameter action: The action will be executed when the object receives the notification named `keyboardWillHideNotification`
    func keyboardWillHide(action: @escaping (KeyboardActionInfo) -> ()) {
        observe(UIApplication.keyboardWillHideNotification) { [unowned self] (notification) in
            let info = self.info(for: notification)
            action(info)
        }
    }
        
    /// The action executed when the keyboard did show. Object observes the  notification named `keyboardDidShowNotification` and executes the action when it receives the notification that the keyboard did show
    /// - Parameter action: The action will be executed when the object receives the notification named `keyboardDidShowNotification`
    func keyboardDidShow(action: @escaping (KeyboardActionInfo) -> ()) {
        observe(UIApplication.keyboardDidShowNotification) {  [unowned self] (notification) in
            let info = self.info(for: notification)
            action(info)
        }
    }
    
    /// The action executed when the keyboard did hide. Object observes the  notification named `keyboardDidHideNotification` and executes the action when it receives the notification that the keyboard did hide
    /// - Parameter action: The action will be executed when the object receives the notification named `keyboardDidHideNotification`
    func keyboardDidHide(action: @escaping (KeyboardActionInfo) -> ()) {
        observe(UIApplication.keyboardDidHideNotification) {  [unowned self] (notification) in
            let info = self.info(for: notification)
            action(info)
        }
    }
    
    private func info(for notification: NSNotification) -> KeyboardActionInfo {
        let info = KeyboardActionInfo()
        if let animationCure = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? UIView.AnimationOptions {
            info.animationCure = animationCure
        }
        info.animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0
        
        if let beginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            info.beginFrame = beginFrame
        }
        
        if let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            info.endFrame = endFrame
        }
        
        
        if let isLocalString = notification.userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? String, isLocalString == "1" {
            info.isLocal = true
        }
        
        return info
    }
}
