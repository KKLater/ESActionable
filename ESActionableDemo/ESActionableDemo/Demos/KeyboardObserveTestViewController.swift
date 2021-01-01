//
//  KeyboardObserveTestViewController.swift
//  ESActionsDemo
//
//  Created by 罗树新 on 2020/12/31.
//

import UIKit
import ESActionable

class KeyboardObserveTestViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardWillShow { [unowned self] (info) in
            let text = "keyboardWillShow:\n\n    animationCure: \(String(describing: info.animationCure)),\n    animationDuration: \(info.animationDuration),\n    beginFrame: \(String(describing: info.beginFrame)), \n    endFrame: \(String(describing: info.endFrame)), \n    isLocal: \(info.isLocal)"
            self.textView.text = text
        }
        
        keyboardDidShow {[unowned self] (info) in
            let text = "keyboardDidShow:\n\n    animationCure: \(String(describing: info.animationCure)),\n    animationDuration: \(info.animationDuration),\n    beginFrame: \(String(describing: info.beginFrame)), \n    endFrame: \(String(describing: info.endFrame)), \n    isLocal: \(info.isLocal)"
            self.textView.text = text
        }
        
        keyboardWillHide { [unowned self] (info) in
            let text = "keyboardWillHide:\n\n    animationCure: \(String(describing: info.animationCure)),\n    animationDuration: \(info.animationDuration),\n    beginFrame: \(String(describing: info.beginFrame)), \n    endFrame: \(String(describing: info.endFrame)), \n    isLocal: \(info.isLocal)"
            self.textView.text = text
        }
        
        keyboardDidHide { [unowned self] (info) in
            let text = "keyboardDidHide:\n\n    animationCure: \(String(describing: info.animationCure)),\n    animationDuration: \(info.animationDuration),\n    beginFrame: \(String(describing: info.beginFrame)), \n    endFrame: \(String(describing: info.endFrame)), \n    isLocal: \(info.isLocal)"
            self.textView.text = text
        }
        
        textView.tap { [unowned self] in
            self.view.endEditing(true)
        }
    }
}
