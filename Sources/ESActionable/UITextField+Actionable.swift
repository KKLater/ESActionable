//
//  File.swift
//  
//
//  Created by 罗树新 on 2021/1/11.
//

import UIKit

private var delegateTargetKey: UInt8 = 0
public extension UITextField {
    
    fileprivate var delegateTarget: UITextFieldDelegateTarget! {
        set {
            objc_setAssociatedObject(self, &delegateTargetKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            var delegateTarget = objc_getAssociatedObject(self, &delegateTargetKey) as? UITextFieldDelegateTarget
            if delegateTarget == nil {
                delegateTarget = UITextFieldDelegateTarget()
                self.delegateTarget = delegateTarget
            }
            return delegateTarget!
        }
    }
    
    func textDidChanged() {
        observe(UITextField.textDidChangeNotification) { (notifictaion) in
            print("notifictaion")
        }
    }
    
    func textDidBeginEditing() {
        observe(UITextField.textDidBeginEditingNotification) { (notifictaion) in
            print("notifictaion")
        }
    }
    
    func textDidEndEditing() {
        observe(UITextField.textDidEndEditingNotification) { (notifictaion) in
            print("notifictaion")
        }
    }
    
    func shouldBeginEditing<T: UITextField>(action: @escaping (T) -> Bool) {
        self.delegate = self.delegateTarget
        let action = ReturnBoolParametizedAction(action)
        action.key = "textFieldShouldBeginEditing"
        delegateTarget.retain(action)
    }
    
    func didBeginEditing<T: UITextField>(action: @escaping (T) -> Void) {
        self.delegate = self.delegateTarget
        let action = ParametizedAction(action)
        action.key = "textFieldDidBeginEditing"
        delegateTarget.retain(action)
    }
    
    func shouldEndEditing<T: UITextField>(action: @escaping (T) -> Bool) {
        self.delegate = self.delegateTarget
        let action = ReturnBoolParametizedAction(action)
        action.key = "textFieldShouldEndEditing"
        delegateTarget.retain(action)
    }
    
    func didEndEditing<T: UITextField>(action: @escaping (T) -> Void) {
        self.delegate = self.delegateTarget
        let action = ParametizedAction(action)
        action.key = "textFieldDidEndEditing"
        delegateTarget.retain(action)
    }
    
    @available(iOS 10.0, *)
    func didEndEditing<T: UITextField>(action: @escaping (T, UITextField.DidEndEditingReason) -> Void) {
        self.delegate = self.delegateTarget
        let action = TextFieldDidEndEditingAction(action)
        action.key = "textFieldDidEndEditingReason"
        delegateTarget.retain(action)
    }
    
    
    func shouldChangeCharacters<T: UITextField>(action: @escaping (T, NSRange, String) -> Bool) {
            self.delegate = self.delegateTarget
            let action = TextFieldShouldChangeCharacters(action)
            action.key = "textFieldShouldChangeCharacters"
            delegateTarget.retain(action)
    }
    
    func didChangeSelection<T: UITextField>(action: @escaping (T) -> Void ) {
        self.delegate = self.delegateTarget
        let action = ParametizedAction(action)
        action.key = "textFieldDidChangeSelection"
        delegateTarget.retain(action)
    }
    
    func shouldClear<T: UITextField>(action: @escaping (T) -> Bool ) {
        self.delegate = self.delegateTarget
        let action = ReturnBoolParametizedAction(action)
        action.key = "textFieldShouldClear"
        delegateTarget.retain(action)
    }
    
    func shouldReturn<T: UITextField>(action: @escaping (T) -> Bool ) {
        self.delegate = self.delegateTarget
        let action = ReturnBoolParametizedAction(action)
        action.key = "textFieldShouldReturn"
        delegateTarget.retain(action)
    }
}

@available(iOS 10.0, *)
private class TextFieldDidEndEditingAction<T: Any>: Actionable {
    var selector: Selector = #selector(perform(textField:reason:))
    public var key: String = ProcessInfo.processInfo.globallyUniqueString
    var action: (_ textField: T, _ reason: UITextField.DidEndEditingReason) -> Void
    
    init(_ action: @escaping (_ textField: T, _ reason: UITextField.DidEndEditingReason) -> Void) {
        self.action = action
    }
    
    @objc func perform(textField: Any, reason: UITextField.DidEndEditingReason) {
        self.action(textField as! T, reason)
    }
}
private class TextFieldShouldChangeCharacters<T: Any>: Actionable {
    public var key: String = ProcessInfo.processInfo.globallyUniqueString
    
    /// This `selector` is used to perform the action
    public var selector: Selector = #selector(perform(textField:range:replacementString:))
    
    var action: (_ textField: T, _ range: NSRange, _ replacementString: String) -> Bool
    
    init(_ action: @escaping (_ textField: T, _ range: NSRange, _ replacementString: String) -> Bool) {
        self.action = action
    }
    
    @objc func perform(textField: Any, range: NSRange, replacementString: String) -> Bool {
        self.action(textField as! T, range, replacementString)
    }
}

private class ReturnBoolParametizedAction<T: Any>: Actionable {
    
    /// The `key` used to manage actions through `retain` or `release` method
    /// - Note：The default value is `ProcessInfo.processInfo.globallyUniqueString`
    public var key: String = ProcessInfo.processInfo.globallyUniqueString
    
    /// This `selector` is used to perform the action
    public var selector: Selector = #selector(perform)
    
    /// This `action` will be executed when the `selector` method of `Actionable` protocol is called
    var action: (T) -> Bool
    
    /// Creat an `VoidAction` with an action
    /// - Parameter action: This `action` will be executed when the `selector` method of `Actionable` protocol is called
    /// - Returns: An `Actionable` `Voidaction` object to be stored
    init(_ action: @escaping (T) -> Bool) {
        self.action = action
    }
    
    /// Execute action
    @objc func perform(parameters: Any) -> Bool {
        return action(parameters as! T)
    }
}


fileprivate class UITextFieldDelegateTarget:NSObject, UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let action = actions["textFieldShouldBeginEditing"] as? ReturnBoolParametizedAction<UITextField> {
            return action.perform(parameters: textField)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let action = actions["textFieldDidBeginEditing"] as? ParametizedAction<UITextField> {
            action.perform(parameters: textField)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let action = actions["textFieldShouldEndEditing"] as? ReturnBoolParametizedAction<UITextField> {
            return action.perform(parameters: textField)
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let action = actions["textFieldDidEndEditing"] as? ParametizedAction<UITextField> {
            action.perform(parameters: textField)
        }
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let action = actions["textFieldDidEndEditingReason"] as? ParametizedAction<UITextField> {
            action.perform(parameters: textField)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let action = actions["textFieldShouldChangeCharacters"] as? TextFieldShouldChangeCharacters<UITextField> {
            return action.perform(textField: textField, range: range, replacementString: string)
        }
        return false
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        if let action = actions["textFieldDidChangeSelection"] as? ParametizedAction<UITextField> {
            action.perform(parameters: textField)
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let action = actions["textFieldShouldClear"] as? ReturnBoolParametizedAction<UITextField> {
            return action.perform(parameters: textField)
        }
        return false

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let action = actions["textFieldShouldReturn"] as? ReturnBoolParametizedAction<UITextField> {
            return action.perform(parameters: textField)
        }
        return false
    }
}
