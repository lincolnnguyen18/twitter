//
//  LoginViewViewController.swift
//  Twitter
//
//  Created by Lincoln Nguyen on 2/9/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

extension UIView {
    func fadeIn(_ duration: TimeInterval? = 0.5, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        // let oldWidth = self.frame.size.width
        // self.frame.size.width = 0
        
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        
        self.isHidden = false
        UIView.animate(withDuration: duration!, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, animations: {
            self.alpha = 1
            // self.frame.size.width = oldWidth
            
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            
        }, completion: {(value: Bool) in
            if let complete = onCompletion {complete()}
        })
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.01, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!, animations: {self.alpha = 0}, completion: {(value: Bool) in
            self.isHidden = true
            if let complete = onCompletion {complete()}
        })
    }
}

class LoginViewViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loginButton.layer.cornerRadius = self.loginButton.frame.size.width / 10
        self.loginButton.layer.masksToBounds = true
        // btn.removeFromSuperview()
        // btn.isHidden = true
        btn.fadeOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // btn.isHidden = true
        btn.fadeOut()
    }
    
    // override func viewWillDisappear(_ animated: Bool) {
    //     super.viewWillDisappear(animated)
    //     btn.isHidden = false
    // }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            
            // UIView.animate(withDuration: 3, animations: {
            //     btn.isHidden = false
            // })
            btn.fadeIn()
        }
        btn.fadeOut()
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let myUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: myUrl, success: {
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            
            // UIView.animate(withDuration: 3, animations: {
            //     btn.isHidden = false
            // })
            
            btn.fadeIn()
            
        }, failure: { (Error) in
            print("Could not log in! \(Error)")
        })
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
