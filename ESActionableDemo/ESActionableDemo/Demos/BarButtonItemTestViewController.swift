//
//  BarButtonItemTestViewController.swift
//  ESActionsDemo
//
//  Created by 罗树新 on 2020/12/30.
//

import UIKit
import ESActionable

class BarButtonItemTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit) { [unowned self] (item) in
            print("edit")
            self.showAlert("edit")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
