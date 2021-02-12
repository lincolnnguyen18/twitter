//
//  TweetViewController.swift
//  Twitter
//
//  Created by Lincoln Nguyen on 2/10/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

protocol TweetVCDelegate: class {
    func refreshTweets()
}

class TweetViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    weak var delegate: TweetVCDelegate?
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let charLimit = 280
        let totalChar = tweetTextView.text.count + (text.count - range.length)
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        print(280 - newText.count)
        charCountLabel.text = "\(charLimit - totalChar) characters remaining"
        if newText.count > 280 {
            tweetButton.isEnabled = false
            charCountLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else {
            tweetButton.isEnabled = true
            charCountLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        if tweetTextView.frame.size.height > 250.0 {
            tweetTextView.textContainer.heightTracksTextView = false
            tweetTextView.isScrollEnabled = true
        }
        // return newText.count < charLimit + 50
        // return (totalChar < (charLimit + 50))
        return true
    }
    
    var placeholderLabel: UILabel!
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tweetTextView.becomeFirstResponder()
        tweetTextView.delegate = self
        tweetTextView.textContainer.heightTracksTextView = true
        tweetTextView.isScrollEnabled = false
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "What's happening?"
        placeholderLabel.sizeToFit()
        tweetTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tweetTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tweetTextView.text.isEmpty
        
        self.line.layer.cornerRadius = self.line.frame.size.width / 50
        self.line.layer.masksToBounds = true
        
        self.profileImageView.image = UIImage(named: "gif-icon")
        
        let myUrl = "https://api.twitter.com/1.1/account/verify_credentials.json"
        let myParams: [String:Any] = ["include_entities":false]
        TwitterAPICaller.client?.getDictionaryRequest(url: myUrl, parameters: myParams, success: { (user) in
            print(user)
            let newUrl = self.replaceMatches(for: "_normal\\.", inString: user["profile_image_url_https"] as! String, withString: "\\.")
            // print(newUrl!)
            let imageUrl = URL(string: (newUrl)!)
            let data = try? Data(contentsOf: imageUrl!)
        
            if let imageData = data {
                self.profileImageView.image = UIImage(data: imageData)
            }
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.layer.masksToBounds = true
            // self.profileImageView.layer.borderWidth = 2
            // self.profileImageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }, failure: { (Error) in
            print("Error in getting user: \(Error)")
        })
    }
    
    private func replaceMatches(for pattern: String, inString string: String, withString replacementString: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return string
        }
        
        let range = NSRange(string.startIndex..., in: string)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: replacementString)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.delegate?.refreshTweets()
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                self.dismiss(animated: true, completion: nil)
                print("Error posting tweet \(error)")
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    //     self.dismiss(animated: flag)
    //     delegate?.refreshTweets()
    // }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
