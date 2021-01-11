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
    func didChangeSelection<T: UITextField>(action: @escaping (T) -> Void ) {
        self.delegate = self.delegateTarget
        let action = ParametizedAction(action)
        action.key = "textFieldDidChangeSelection"
        retain(action)
    }
    
    func didEndEditing<T: UITextField>(action: @escaping (T) -> Void) {
        self.delegate = self.delegateTarget
        let action = ParametizedAction(action)
        action.key = "textFieldDidEndEditing"
        retain(action)
    }
}


fileprivate class UITextFieldDelegateTarget:NSObject, UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        if let action = actions["textFieldDidChangeSelection"] as? ParametizedAction<UITextField> {
            action.perform(parameters: textField)
        }
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let action = actions["textFieldDidEndEditing"] as? ParametizedAction<UITextField> {
            action.perform(parameters: textField)
        }
    }
}
