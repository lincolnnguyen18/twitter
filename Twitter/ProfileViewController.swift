//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Lincoln Nguyen on 2/11/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.profileImageView.image = UIImage(named: "gif-icon")
        let myUrl = "https://api.twitter.com/1.1/account/verify_credentials.json"
        let myParams: [String:Any] = ["include_entities":false]
        TwitterAPICaller.client?.getDictionaryRequest(url: myUrl, parameters: myParams, success: { (user) in
            // print(user)
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
            
            self.nameLabel.text = user["name"] as? String
            self.descriptionLabel.text = user["description"] as? String
            // self.followingLabel.text = "\(user["friends_count"] as? Int ?? 0) Following"
            // self.followersLabel.text = "\(user["followers_count"] as? Int ?? 0) Followers"
            // self.tweetsLabel.text = "\(user["statuses_count"] as? Int ?? 0) Tweets"
            self.followersLabel.attributedText = NSMutableAttributedString()
                .bold("\(user["followers_count"] as? Int ?? 0) ")
                .greyHighlight("Followers")
            self.followingLabel.attributedText = NSMutableAttributedString()
                .bold("\(user["friends_count"] as? Int ?? 0) ")
                .greyHighlight("Following")
            self.tweetsLabel.attributedText = NSMutableAttributedString()
                .bold("\(user["followers_count"] as? Int ?? 0) ")
                .greyHighlight("Tweets")
        }, failure: { (Error) in
            print("Error in getting user: \(Error)")
        })
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    private func replaceMatches(for pattern: String, inString string: String, withString replacementString: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return string
        }
        
        let range = NSRange(string.startIndex..., in: string)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: replacementString)
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

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 17 }
    var boldFont:UIFont { return UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont.systemFont(ofSize: fontSize)}
    
    func boldName(_ value: String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func greyHandleAndTim(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func greyHighlight(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font:  normalFont,
            .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

extension String {
    /*
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     - Parameter length: Desired maximum lengths of a string
     - Parameter trailing: A 'String' that will be appended after the truncation.
     
     - Returns: 'String' object.
     */
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}

// // Swift 4.0 Example
// let str = "I might be just a little bit too long".truncate(10) // "I might be…"
