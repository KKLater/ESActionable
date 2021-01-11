//
//  File.swift
//  
//
//  Created by 罗树新 on 2021/1/11.
//

import UIKit

public extension UITextField {
    
    func didChangeSelection<T: UITextField>(action: @escaping (T) -> Void ) {
        delegate = self
        let action = ParametizedAction(action)
        action.key = "textFieldDidChangeSelection"
        retain(action)
    }
    
    func didEndEditing<T: UITextField>(action: @escaping (T) -> Void) {
        delegate = self
        let action = ParametizedAction(action)
        action.key = "textFieldDidEndEditing"
        retain(action)
    }
}

extension UITextField: UITextFieldDelegate {
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
