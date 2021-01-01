//
//  GestureRecognizerTestViewController.swift
//  ESActionsDemo
//
//  Created by 罗树新 on 2020/12/30.
//

import UIKit
import ESActionable

class GestureRecognizerTestViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = textView.tap { [unowned self] (view) in
            print("view tap")
            self.showAlert("单击响应")
        }

        let tap2 = textView.tap(taps: 2, action: { [unowned self] (view) in
            print("view tap 2")
            self.showAlert("双击响应")
        })

        let longPress = textView.longPress { [unowned self] in
            print("view longPress")
            self.showAlert("长按手势响应")
        }
        tap.require(toFail: tap2)
        tap2.require(toFail: longPress)
    }
    
    
}
