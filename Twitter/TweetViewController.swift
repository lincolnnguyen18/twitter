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
    weak var delegate: TweetVCDelegate?
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let charLimit = 280
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        print(280 - newText.count)
        charCountLabel.text = "\(280 - newText.count) characters remaining"
        return newText.count < charLimit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tweetTextView.becomeFirstResponder()
        tweetTextView.delegate = self
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
