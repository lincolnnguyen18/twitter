//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Lincoln Nguyen on 2/9/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit
import Lightbox
import SwiftDate
// import DateToolsSwift

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

// override UIButton.isHighlighted {
//     didSet {
//         if (highlighted) {
//             btn.backgroundColor = #colorLiteral(red: 0.1066790186, green: 0.6003596351, blue: 0.903967756, alpha: 1)
//         } else {
//             btn.backgroundColor = #colorLiteral(red: 0.1137254902, green: 0.631372549, blue: 0.9490196078, alpha: 1)
//         }
//     }
// }

var btn = highlightButton(type: .custom)
func floatingButton() {
    let circleLocation = 75
    let circleWidth = 55
    // btn.frame = CGRect(x: locationX, y: locationY, width: circleWidth, height: circleWidth)
    btn.frame = CGRect(x: Int(UIApplication.shared.keyWindow!.bounds.width) - circleLocation, y: Int(UIApplication.shared.keyWindow!.bounds.height) - circleLocation - 49, width: circleWidth, height: circleWidth)
    // btn.setTitle("All Defects", for: .normal)
    btn.setImage(UIImage(named: "compose"), for: UIControl.State.normal)
    
    btn.backgroundColor = #colorLiteral(red: 0.1137254902, green: 0.631372549, blue: 0.9490196078, alpha: 1)
    btn.clipsToBounds = true
    btn.layer.cornerRadius = btn.frame.width / 2
    // btn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    // btn.layer.borderWidth = 1.0
    btn.layer.masksToBounds = false
    btn.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    btn.layer.shadowOffset = CGSize(width: 20, height: 20)
    // btn.layer.shadowOffset = .zero
    btn.layer.shadowOpacity = 0.8
    btn.layer.shadowRadius = CGFloat(circleWidth / 2)
    // btn.layer.shadowRadius = 20
    // btn.layer.shadowPath = UIBezierPath(rect: btn.bounds).cgPath
    btn.layer.shadowPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: btn.frame.width - 20, height: btn.frame.height - 20)).cgPath
    
    btn.adjustsImageWhenHighlighted = false
    
    // btn..add
    if let window = UIApplication.shared.keyWindow {
        window.addSubview(btn)
    }
}

class HomeTableViewController: UITableViewController, TweetVCDelegate, LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {
    // @IBOutlet weak var floatingButton: UIButton!
    //
    // override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //     let off = scrollView.contentOffset.y
    //     floatingButton.frame = CGRect(x: 285, y: off + 485, width: floatingButton.frame.size.width, height: floatingButton.frame.size.height)
    // }
    
    @IBAction func buttonTapped(_ sender: highlightButton) {
        // if sender.isHighlighted {
        //     sender.backgroundColor = #colorLiteral(red: 0.1019546434, green: 0.5737721751, blue: 0.8639347404, alpha: 1)
        // } else {
        //     sender.backgroundColor = #colorLiteral(red: 0.1137254902, green: 0.631372549, blue: 0.9490196078, alpha: 1)
        // }
        print("sucess!")
        performSegue(withIdentifier: "toTweet", sender: self)
    }
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
    
    var tweetArray = [NSDictionary]()
    var numberofTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController, let tweetVC = nav.topViewController as? TweetViewController {
            tweetVC.delegate = self
        }
    }
    
    func refreshTweets() {
        // disable temporarily ************************************************************************************************
        // loadTweets()
        print("refresshhhhhahhhhhhh")
    }
    
    override func viewDidLoad() {
        numberofTweets = 10
        super.viewDidLoad()
        // disable temporarily ************************************************************************************************
        
        floatingButton()
        
        btn.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControl.Event.touchUpInside)
        
        // loadTweets()
        // self.isModalInPresentation = true
        // self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        // let image: UIImage = UIImage(named: "TwitterLogo")!
        // let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        // imageView.contentMode = .scaleAspectFit
        // imageView.image = image
        // self.navigationItem.titleView = imageView
        
        // self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 30)!]
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // override func viewDidAppear(_ animated: Bool) {
    //     super.viewDidAppear(animated)
    //     numberofTweets = 10
    //     DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
    //         print("TIME DOVER!")
    //     }
    //     // print("WHY NOT WORKING!?!?!?")
    // }
    
    @objc func loadTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams: [String:Any] = ["count": numberofTweets!, "include_entities": "true"]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            // print(tweets)
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retrieve tweets! oh no!!")
        })
    }
    
    func loadMoreTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberofTweets = numberofTweets + 1
        let myParams = ["count": numberofTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Could not retrieve tweets! oh no!!")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            // disable temporarily ************************************************************************************************
            // loadMoreTweets()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let tweet = tweetArray[indexPath.row]
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        // print(user)
        print(tweetArray[indexPath.row])
        
        // cell.userNameLabel.text = user["name"] as? String
        
        // let attributes: [NSAttributedString.Key: Any] = [
        //     .font: font
        // ]
        
        // let quote = (user["name"] as? String)!
        // let font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        // let attributes: [NSAttributedString.Key: Any] = [
        //     .font: font
        // ]
        // var attributedQuote = NSAttributedString(string: quote, attributes: attributes)
        
        // let truncName = (user["name"] as! String).trunc(length: 10)
        
        
        // let test = "123456789fjewlafjlaw;j"
        // print(test.trunc(length: 9))
        
        /*
        @@@@@@@@@@ @@@@@@@ · 45m
        10, 1, 7, 3, 3
        */
        
        // cell.userNameLabel.attributedText = NSMutableAttributedString()
        //     .boldName("\(truncName) ")
            
        
        // cell.userNameLabel.attributedText = NSMutableAttributedString()
        //     .bold("\(user["name"] as? String)")
        
        cell.userNameLabel.text = user["name"] as? String
        // cell.userNameLabel.addCharacterSpacing(kernValue: 0.2)
        
        
        cell.handleLabel.text = "@\(user["screen_name"] as! String)"
        cell.handleLabel.addCharacterSpacing(kernValue: 0.2)
        
        let timeString = tweet["created_at"] as! String
        
        // let parsedTime = timeString.toDate("ddd MM d HH:mm:ss K yyyy")
        let parsedTime = timeString.toDate("ccc MMM dd HH:mm:ss xxxx yyyy")
        // print(parsedTime?.toFormat("dd MMM yyyy 'at' HH:mm:ss"))
        
        // Goal: 2021-02-14 13:39:34 +0000
        
        let formattedDate = parsedTime?.toFormat("yyyy'-'MM'-'dd' 'HH:mm:ss' 'xxxx") as! String
        print(formattedDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        // dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: formattedDate)
        print(date)
        
        // print(parsedTime - Date()).toRelative()
        let testRelativeTime = (parsedTime?.toRelative(since: DateInRegion(), style: RelativeFormatter.Style.init(flavours: [RelativeFormatter.Flavour.longTime], gradation: RelativeFormatter.Gradation.canonical(), allowedUnits: [.now, .second, .minute]), locale: Locales.english))
        print(testRelativeTime!)
        let testRelativeTimeStr = testRelativeTime as! String
        let testRelativeTimeComponents = testRelativeTimeStr.components(separatedBy: " ")
        print(testRelativeTimeComponents)
        
        cell.timeLabel.text = " · \(testRelativeTimeComponents[0])\(testRelativeTimeComponents[1].prefix(1))"
        
        
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        cell.tweetContent.addCharacterSpacing(kernValue: 0.2)
        cell.tweetContent.addInterlineSpacing(spacingValue: 5)
        
        //
        // var style = NSMutableParagraphStyle()
        // let stringValue = cell.tweetContent.text!
        // let attrString = NSMutableAttributedString(string: stringValue)
        // style.lineSpacing = 36
        // style.minimumLineHeight = 30
        // attrString.addAttribute(
        //     .paragraphStyle,
        //     value: NSParagraphStyle
        //     range: NSRange(location: 0, length: attrString.length)
        // ))
        // cell.tweetContent.attributedText = attrString
        //
        // cell.tweetContent.attributedText = attrString
        //
        var media1: UIImage?, media2: UIImage?, media3: UIImage?, media4: UIImage?
        
        // if media1 == nil && media2 == nil && media3 == nil && media4 == nil {
        //     cell.mediaStack.
        // }
        
        
        // let entities = tweetArray[indexPath.row]["entities"] as? NSDictionary
        // print(entities ?? "nil")
        let extendedEntities = tweetArray[indexPath.row]["extended_entities"] as? NSDictionary
        // print(extendedEntities ?? "nil")
        
        // let media1Dict = entities?["media"] as? NSDictionary
        // print(media1Dict)
        
        // if let pictureDict = snapshot.value["picture"] as? [String:AnyObject]{
        //
        //     if let dataDict = pictureDict.value["data"] as? [String:AnyObject]{
        //
        //         self.pictureURL =  dataDict.value["url"] as! String
        //
        //     }
        // }
        
        // let url = ((snapshot.value as? NSDictionary)?["picture"] as? NSDictionary)?["url"] as? String
        
        // if let media1Array = entities?["media"] as? [AnyObject] {
        //     // print("Size of media1Array is \(media1Array.count)")
        //     // print(media1Array[0])
        //     if let media1Dict = media1Array[0] as? NSDictionary {
        //         // print(media1Dict)
        //         if let media1Url = URL(string: media1Dict["media_url_https"] as! String) {
        //             // print(media1Url)
        //             if let imageData = try? Data(contentsOf: media1Url) {
        //                 // print("imageData1 valid!")
        //                 media1 = UIImage(data: imageData)
        //             }
        //         }
        //     }
        //     // if let media1Url = URL(string: media1Dict["media_url_https"] as! String) {
        //     //     print(media1Url)
        //     //     if let imageData = try? Data(contentsOf: media1Url) {
        //     //         print("imageData1 valid!")
        //     //         media1 = UIImage(data: imageData)
        //     //         cell.media1.image = media1
        //     //     }
        //     // }
        // }
        
        if let mediaArray = extendedEntities?["media"] as? [AnyObject] {
            // print("Size of extended_entities is \(mediaArray.count)")
            
            if mediaArray.count >= 1 {
                if let mediaDict = mediaArray[0] as? NSDictionary {
                    // print(media1Dict)
                    if let mediaUrl = URL(string: mediaDict["media_url_https"] as! String) {
                        if let imageData = try? Data(contentsOf: mediaUrl) {
                            // print("imageData1 valid!")
                            media1 = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            if mediaArray.count >= 2 {
                if let mediaDict = mediaArray[1] as? NSDictionary {
                    // print(media2Dict)
                    if let mediaUrl = URL(string: mediaDict["media_url_https"] as! String) {
                        if let imageData = try? Data(contentsOf: mediaUrl) {
                            // print("imageData2 valid!")
                            media2 = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            if mediaArray.count >= 3 {
                if let mediaDict = mediaArray[2] as? NSDictionary {
                    // print(media3Dict)
                    if let mediaUrl = URL(string: mediaDict["media_url_https"] as! String) {
                        if let imageData = try? Data(contentsOf: mediaUrl) {
                            // print("imageData3 valid!")
                            media3 = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            if mediaArray.count >= 4 {
                if let mediaDict = mediaArray[3] as? NSDictionary {
                    // print(media4Dict)
                    if let mediaUrl = URL(string: mediaDict["media_url_https"] as! String) {
                        if let imageData = try? Data(contentsOf: mediaUrl) {
                            // print("imageData4 valid!")
                            media4 = UIImage(data: imageData)
                        }
                    }
                }
            }
            // if let media1Url = URL(string: media1Dict["media_url_https"] as! String) {
            //     print(media1Url)
            //     if let imageData = try? Data(contentsOf: media1Url) {
            //         print("imageData1 valid!")
            //         media1 = UIImage(data: imageData)
            //         cell.media1.image = media1
            //     }
            // }
        }
        
        cell.setMedia(media1, media2, media3, media4)
        
        // let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        cell.media1.addGestureRecognizer(getGestureRecognizer())
        cell.media2.addGestureRecognizer(getGestureRecognizer())
        cell.media3.addGestureRecognizer(getGestureRecognizer())
        cell.media4.addGestureRecognizer(getGestureRecognizer())
        
        cell.media1.isUserInteractionEnabled = true
        cell.media2.isUserInteractionEnabled = true
        cell.media3.isUserInteractionEnabled = true
        cell.media4.isUserInteractionEnabled = true
        
        let newImageUrlStr = self.replaceMatches(for: "_normal\\.", inString: user["profile_image_url_https"] as! String, withString: "\\.")
        // let imageUrl = URL(string: newImageUrlStr as? String)!)
        let imageUrl = URL(string: (newImageUrlStr)!)
        
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
            cell.profileImageView.layer.masksToBounds = true
            cell.profileImageView.layer.borderColor = #colorLiteral(red: 0.8729855169, green: 0.8729855169, blue: 0.8729855169, alpha: 1)
            cell.profileImageView.layer.borderWidth = 0.5
        }
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    
    func getGestureRecognizer() -> UITapGestureRecognizer {
        var tapRecognizer = UITapGestureRecognizer()
        tapRecognizer = UITapGestureRecognizer (target: self, action: #selector(didTapImageView(_:)))
        
        return tapRecognizer
    }
    
    @objc private func didTapImageView(_ sender: UITapGestureRecognizer) {
        print("An media tpaped!", sender)
        // performSegue(withIdentifier: "toMedia", sender: self)
        let tappedImage = sender.view as! UIImageView
        let tappedCell = sender.view?.superview?.superview?.superview as! TweetCellTableViewCell
        
        print(tappedImage.tag)
        
        var mediaArray: [LightboxImage] = []
        
        if tappedCell.media1.image != nil {
            mediaArray.append(LightboxImage(image: tappedCell.media1.image!))
        }
        if tappedCell.media2.image != nil {
            mediaArray.append(LightboxImage(image: tappedCell.media2.image!))
        }
        if tappedCell.media3.image != nil {
            mediaArray.append(LightboxImage(image: tappedCell.media3.image!))
        }
        if tappedCell.media4.image != nil {
            mediaArray.append(LightboxImage(image: tappedCell.media4.image!))
        }
        
        // let imageToSend = cell.image
        // let images = [
        //     LightboxImage(image: mediaArray[0]),
        //     LightboxImage(image: mediaArray[1]),
        //     LightboxImage(image: mediaArray[2]),
        //     LightboxImage(image: mediaArray[3])
        // ]
        
        let controller = LightboxController(images: mediaArray)
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.dynamicBackground = true
        controller.goTo(tappedImage.tag)
        present(controller, animated: true, completion: nil)
    }
    
    private func replaceMatches(for pattern: String, inString string: String, withString replacementString: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return string
        }
        
        let range = NSRange(string.startIndex..., in: string)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: replacementString)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

private extension UILabel {
    
    // MARK: - spacingValue is spacing that you need
    func addInterlineSpacing(spacingValue: CGFloat = 2) {
        
        // MARK: - Check if there's any text
        guard let textString = text else { return }
        
        // MARK: - Create "NSMutableAttributedString" with your text
        let attributedString = NSMutableAttributedString(string: textString)
        
        // MARK: - Create instance of "NSMutableParagraphStyle"
        let paragraphStyle = NSMutableParagraphStyle()
        
        // MARK: - Actually adding spacing we need to ParagraphStyle
        paragraphStyle.lineSpacing = spacingValue
        
        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
            ))
        
        // MARK: - Assign string that you've modified to current attributed Text
        attributedText = attributedString
    }
    
}
