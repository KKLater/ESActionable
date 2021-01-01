//
//  UIBarButtonItem+Actionable.swift
//  ESActionable
//
//  Created by 罗树新 on 2020/12/29.
//

import UIKit

public extension UIBarButtonItem {
    
    convenience init<T: UIBarButtonItem>(image: UIImage?, landscapeImagePhone: UIImage? = nil, style: UIBarButtonItem.Style = .plain, action: @escaping (T) -> ()) {
        let actionObj = ParametizedAction(action)
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: actionObj, action: actionObj.selector)
        retain(actionObj)
    }
    
    convenience init(image: UIImage?, landscapeImagePhone: UIImage? = nil, style: UIBarButtonItem.Style = .plain, action: @escaping () -> ()) {
        let actionObj = VoidAction(action)
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: actionObj, action: actionObj.selector)
        retain(actionObj)
    }
    
    convenience init<T: UIBarButtonItem>(title: String?, style: UIBarButtonItem.Style = .plain, action: @escaping (T) -> ()) {
        let actionObj = ParametizedAction(action)
        self.init(title: title, style: style, target: actionObj, action: actionObj.selector)
        retain(actionObj)
    }
    
    convenience init(title: String?, style: UIBarButtonItem.Style = .plain, action: @escaping () -> ()) {
        let actionObj = VoidAction(action)
        self.init(title: title, style: style, target: actionObj, action: actionObj.selector)
        retain(actionObj)
    }
    
    convenience init<T: UIBarButtonItem>(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, action: @escaping (T) -> ()) {
        let actionObj = ParametizedAction(action)
        self.init(barButtonSystemItem: systemItem, target: actionObj, action: actionObj.selector)
        retain(actionObj)
    }
    
    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, action: @escaping () -> ()) {
        let actionObj = VoidAction(action)
        self.init(barButtonSystemItem: systemItem, target:actionObj, action: actionObj.selector)
        retain(actionObj)
    }
}
