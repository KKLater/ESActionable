//
//  UIViewController+Extension.swift
//  ESActionsDemo
//
//  Created by 罗树新 on 2020/12/29.
//

import UIKit

public extension UIViewController {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "关闭", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
