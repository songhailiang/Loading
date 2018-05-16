//
//  ViewController.swift
//  Loading
//
//  Created by songhailiang on 2018/5/9.
//  Copyright © 2018 songhailiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showButtonTouched(_ sender: Any) {
        show()
    }

    @IBAction func alertButtonTouched(_ sender: Any) {
        let alert = UIAlertController(title: "Loading", message: "This is alert message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

//        let alert = UIAlertView(title: "Loading", message: "This is alert view", delegate: nil, cancelButtonTitle: "OK")
//        alert.show()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.show()
        }
    }
    
    @IBAction func themeButtonTouched(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            view.backgroundColor = UIColor.black

            var config = LoadingConfig()
            config.width = 60
            config.radius = 8
            config.style = .whiteLarge
            config.backgroundColor = UIColor.lightGray
            config.color = .red
            Loading.config(config)
        } else {
            view.backgroundColor = UIColor.white

            Loading.config(LoadingConfig())
        }
    }

    func show() {
        print("show loading...")
        Loading.show()
        hide()
    }

    func hide() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
            Loading.hide()
            print("hide loading...")
        }
    }
}

