//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Lincoln Nguyen on 2/9/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, TweetVCDelegate {

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
        loadTweets()
        // self.isModalInPresentation = true
        // self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
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
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        // print(user)
        print(tweetArray[indexPath.row])
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        var media1: UIImage?, media2: UIImage?, media3: UIImage?, media4: UIImage?
        
        
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
            print("Size of extended_entities is \(mediaArray.count)")
            
            if mediaArray.count >= 1 {
                if let media1Dict = mediaArray[0] as? NSDictionary {
                    print(media1Dict)
                    if let media1Url = URL(string: media1Dict["media_url_https"] as! String) {
                        if let imageData = try? Data(contentsOf: media1Url) {
                            print("imageData1 valid!")
                            media1 = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            if mediaArray.count >= 2 {
                if let media2Dict = mediaArray[1] as? NSDictionary {
                    print(media2Dict)
                    if let media2Url = URL(string: media2Dict["media_url_https"] as! String) {
                        if let imageData = try? Data(contentsOf: media2Url) {
                            print("imageData2 valid!")
                            media2 = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            if mediaArray.count >= 3 {
                if let media3Dict = mediaArray[2] as? NSDictionary {
                    print(media3Dict)
                    if let media3Url = URL(string: media3Dict["media_url_https"] as! String) {
                        if let imageData = try? Data(contentsOf: media3Url) {
                            print("imageData3 valid!")
                            media3 = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            if mediaArray.count >= 4 {
                if let media4Dict = mediaArray[3] as? NSDictionary {
                    print(media4Dict)
                    if let media4Url = URL(string: media4Dict["media_url_https"] as! String) {
                        if let imageData = try? Data(contentsOf: media4Url) {
                            print("imageData4 valid!")
                            media3 = UIImage(data: imageData)
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
        
        
        let newImageUrlStr = self.replaceMatches(for: "_normal\\.", inString: user["profile_image_url_https"] as! String, withString: "\\.")
        // let imageUrl = URL(string: newImageUrlStr as? String)!)
        let imageUrl = URL(string: (newImageUrlStr)!)
        
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
            cell.profileImageView.layer.masksToBounds = true
        }
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
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
