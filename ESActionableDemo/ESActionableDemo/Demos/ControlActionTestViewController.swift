//
//  ControlActionTestViewController.swift
//  ESActionsDemo
//
//  Created by 罗树新 on 2020/12/30.
//

import UIKit
import ESActionable

class ControlActionTestViewController: UIViewController {

    var target1: UIControlTarget?
    var target2: UIControlTarget?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(testButton)
        view.addSubview(label1)
        view.addSubview(label2)

        testButton.frame = CGRect(x: 10, y: 400, width: view.bounds.size.width - 20, height: 80)
        label1.frame = CGRect(x: 10, y: 300, width: view.bounds.size.width - 20, height: 60)
        label2.frame = CGRect(x: 10, y: 200, width: view.bounds.size.width - 20, height: 60)

        var count = 0
        target1 = testButton.touchUpInside { [unowned self] in
            print("touchUpInside1")
            self.label1.text = "touchUpInside1"
            count += 1
            if count == 2 {
                self.target2?.remove(for: .touchDown)
                self.showAlert("button remove action touchDown 2")
            }
            
            if count == 5 {
                self.target2?.remove()
                self.showAlert("button remove all action 2")
            }
        }.touchDown { [unowned self] in
            print("touchDown1")
            self.label1.text = "touchDown1"
        }
        
        target2 = testButton.touchUpInside { [unowned self] in
            print("touchUpInside2")
            self.label2.text = "touchUpInside2"
        }.touchDown { [unowned self] in
            print("touchDown2")
            self.label2.text = "touchDown2"
        }
    }
    
    lazy var label1: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    lazy var label2: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var testButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ButtonActionTest", for: .normal)
        return button
    }()

}
