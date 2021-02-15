//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Lincoln Nguyen on 2/9/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit
import SwiftyGif

class TweetCellTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var favedButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton! {
        didSet {
            retweetButton.tintColor = #colorLiteral(red: 0.3568627451, green: 0.4392156863, blue: 0.5137254902, alpha: 1)
        }
    }
    @IBOutlet weak var retweetGreen: UIButton! {
        didSet {
            retweetGreen.tintColor = #colorLiteral(red: 0.09019607843, green: 0.7490196078, blue: 0.3882352941, alpha: 1)
        }
    }
    
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
    @IBOutlet var stupidConsraint: NSLayoutConstraint!
    
    var timeSince: TimeSince? {
        didSet {
            // taskLabel.text = task?.name
            // setState()
            updateTime()
        }
    }
    
    func updateTime() {
        guard let timeSince = timeSince else {
            return
        }
        
        let time = Date().timeIntervalSince(timeSince.start!)
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        // var times: [String] = []
        // if hours > 0 {
        //     times.append("\(hours)h")
        // }
        // if minutes > 0 {
        //     times.append("\(minutes)m")
        // }
        // times.append("\(seconds)s")
        //
        // timeLabel.text = times.joined(separator: " ")
        
        if hours > 0 {
            timeLabel.text = " · \(hours)h"
        } else if minutes > 0 {
            timeLabel.text = " · \(minutes)m"
        } else if seconds > 0 {
            timeLabel.text = " · \(seconds)s"
        }
    }
    
    func setMedia(_ image1: UIImage?, _ image2: UIImage?, _ image3: UIImage?, _ image4: UIImage?) {
        
        // let stupidConstraintCopy = stupidConsraint as! NSLayoutConstraint
        // let squishStack = NSLayoutConstraint(item: mediaStack!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0)
        
        if (image1 == nil && image2 == nil && image3 == nil && image4 ==  nil) {
            // self.mediaStack.removeFromSuperview()
            // self.mediaStack.isHidden = true
            // stupidConsraint.isActive = false
            // self.removeConstraint(stupidConsraint)
            stupidConsraint.constant = -11
            // self.addConstraint(squishStack)
            
        } else {
            // self.addSubview(self.mediaStack)
            // self.mediaStack.isHidden = false
            // stupidConsraint.isActive = true
            // self.addConstraint(stupidConsraint)
            stupidConsraint.constant = 11
            // self.removeConstraint(squishStack)
            
        }
        if image1 != nil {
            self.media1.image = image1
            self.media1.layer.cornerRadius = self.media1.frame.size.width / 15
            self.media1.layer.masksToBounds = true
            self.media1.layer.borderWidth = 0.5
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
            self.media2.layer.borderWidth = 0.5
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
            self.media3.layer.borderWidth = 0.5
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
            self.media4.layer.borderWidth = 0.5
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
                
                do {
                    print("working?")
                    self.favButton.isHidden = true
                    self.favedButton.isHidden = false
                    let gif = try UIImage(gifName: "favoriteAnimate.gif")
                    
                    var testView: UIImageView = UIImageView()
                    // testView.backgroundColor = UIColor.clear
                    // testView.isOpaque = false
                    // testView.layer.zPosition -= 1
                    // self.superview!.superview!.sendSubviewToBack(self.superview!)
                    
                    testView.frame = CGRect(x: -7, y: -7, width: self.favedButton.frame.width + 14, height: self.favedButton.frame.height + 14)
                    
                    // testView.cro
                    
                    self.favedButton.addSubview(testView)
                    
                    self.bringSubviewToFront(self.mediaStack)
                    // self.mediaStack.layer.
                    self.sendSubviewToBack(self.favedButton)
                    
                    testView.setGifImage(gif, loopCount: 1)
                    self.superview!.layoutIfNeeded()
                    
                    // self.favedButton.imageView?.setGifImage(gif, loopCount: 1)
                    // self.favedButton.setImage(gif, for: <#T##UIControl.State#>)
                    // self.heart.removeConstraint(heartWidth)
                    // self.heart.addConstraint(NSLayoutConstraint(item: self.heart!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50))
                    // heartWidth.constant = 53
                    // isFavorited = true
                } catch {
                    print(error)
                }
                
                
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
    
    var isRetweeted = false
    
    @IBAction func retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
            
            UIView.animate(withDuration: 0.03, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                // self.heartWidth.constant = 100
                // self.view.layoutIfNeeded()
                self.retweetGreen.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                // self.greenWidth.constant = 30
                self.superview!.layoutIfNeeded()
            }) { (finished) in
                UIView.animate(withDuration: 0.1, delay: 0.1, animations: {
                    // self.heart.transform = CGAffineTransform.identity
                    self.retweetGreen.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.superview!.layoutIfNeeded()
                })
            }
            
            self.isRetweeted = true
        }, failure: { (Error) in
            print("Error in retweeting: \(Error)")
        })
    }
    
    func setRetweeted(_ isRetweeted:Bool) {
        if (isRetweeted) {
            retweetButton.setImage(UIImage(named: "retweeted2"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
            self.retweetButton.isHidden = true
            self.retweetGreen.isHidden = false
            retweetGreen.setImage(UIImage(named: "retweeted2"), for: .normal)
            self.isRetweeted = true
        } else {
            retweetButton.setImage(UIImage(named: "retweet2"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
            self.retweetButton.isHidden = false
            self.retweetGreen.isHidden = true
            retweetButton.setImage(UIImage(named: "retweet2"), for: .normal)
            self.isRetweeted = false
        }
    }
    
    var favorited:Bool = false
    var tweetId:Int = -1
    // var retweeted:Bool = false
    
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named: "favorited2"), for: UIControl.State.normal)
            self.favButton.isHidden = true
            self.favedButton.isHidden = false
        }
        else {
            favButton.setImage(UIImage(named: "favorite2"), for: UIControl.State.normal)
            self.favButton.isHidden = false
            self.favedButton.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    // override func setSelected(_ selected: Bool, animated: Bool) {
    //     super.setSelected(selected, animated: animated)
    // 
    //     // Configure the view for the selected state
    // }

}
