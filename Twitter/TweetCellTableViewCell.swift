//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Lincoln Nguyen on 2/9/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet var media1: UIImageView! {
        didSet {
            media1.isUserInteractionEnabled = true
        }
    }
    @IBOutlet var media2: UIImageView!
    @IBOutlet var media3: UIImageView!
    @IBOutlet var media4: UIImageView!
    @IBOutlet weak var mediaStack: UIStackView!
    @IBOutlet weak var cellView: UIView!
    
    func setMedia(_ image1: UIImage?, _ image2: UIImage?, _ image3: UIImage?, _ image4: UIImage?) {
        // if (image1 == nil && image2 == nil && image3 == nil && image4 ==  nil) {
        //     // self.mediaStack.removeFromSuperview()
        //     // self.mediaStack.isHidden = true
        // } else {
        if image1 != nil {
            self.media1.image = image1
            self.media1.layer.cornerRadius = self.media1.frame.size.width / 15
            self.media1.layer.masksToBounds = true
            self.media1.layer.borderWidth = 1.2
            self.media1.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.mediaStack.addSubview(media1)
            self.mediaStack.addArrangedSubview(media1)
            // self.media1.isHidden = false
        } else {
            self.mediaStack.removeArrangedSubview(media1)
            // self.media1.isHidden = true
            media1.removeFromSuperview()
        }
        if image2 != nil {
            self.media2.image = image2
            self.media2.layer.cornerRadius = self.media2.frame.size.width / 15
            self.media2.layer.masksToBounds = true
            self.media2.layer.borderWidth = 1.2
            self.media2.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.mediaStack.addSubview(media2)
            self.mediaStack.addArrangedSubview(media2)
            // self.media2.isHidden = false
        } else {
            self.mediaStack.removeArrangedSubview(media2)
            // self.media2.isHidden = true
            media2.removeFromSuperview()
        }
        if image3 != nil {
            self.media3.image = image3
            self.media3.layer.cornerRadius = self.media3.frame.size.width / 15
            self.media3.layer.masksToBounds = true
            self.media3.layer.borderWidth = 1.2
            self.media3.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.mediaStack.addSubview(media3)
            self.mediaStack.addArrangedSubview(media3)
            // self.media3.isHidden = false
        } else {
            self.mediaStack.removeArrangedSubview(media3)
            // self.media3.isHidden = true
            media3.removeFromSuperview()
        }
        if image4 != nil {
            self.media4.image = image4
            self.media4.layer.cornerRadius = self.media4.frame.size.width / 15
            self.media4.layer.masksToBounds = true
            self.media4.layer.borderWidth = 1.2
            self.media4.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.mediaStack.addSubview(media4)
            self.mediaStack.addArrangedSubview(media4)
            // self.media4.isHidden = false
        } else {
            self.mediaStack.removeArrangedSubview(media4)
            // self.media3.isHidden = true
            media4.removeFromSuperview()
        }
        // self.media2.image = image2
        // self.media3.image = image3
        // self.media4.image = image4
        // }
        
        // let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        // self.media1.addGestureRecognizer(tapGestureRecognizer)
        // self.media2.addGestureRecognizer(tapGestureRecognizer)
        // self.media3.addGestureRecognizer(tapGestureRecognizer)
        // self.media4.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (Error) in
                print("Favorite did not succeed: \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (Error) in
                print("Unfavorite did not succeed: \(Error)")
            })
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (Error) in
            print("Error in retweeting: \(Error)")
        })
    }
    
    func setRetweeted(_ isRetweeted:Bool) {
        if (isRetweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    var favorited:Bool = false
    var tweetId:Int = -1
    // var retweeted:Bool = false
    
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // override func setSelected(_ selected: Bool, animated: Bool) {
    //     super.setSelected(selected, animated: animated)
    // 
    //     // Configure the view for the selected state
    // }

}
