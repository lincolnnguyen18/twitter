//
//  APIManager.swift
//  Twitter
//
//  Created by Dan on 1/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterAPICaller: BDBOAuth1SessionManager {    
    static let client = TwitterAPICaller(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "uFTmFW66AAMEUwx3rZlZDMSCf", consumerSecret: "LtlxIoQpBvHcqjpSMIA9Gs2E9wCJbr7xkx9EpSdBYoNedaZUgh")
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    var currentAccessToken: BDBOAuth1Credential?
    let secret = "LtlxIoQpBvHcqjpSMIA9Gs2E9wCJbr7xkx9EpSdBYoNedaZUgh"
    var theUrl: URL?
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterAPICaller.client?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            self.currentAccessToken = accessToken
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    }
    
    // func login(url: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
    //     loginSuccess = success
    //     loginFailure = failure
    //     TwitterAPICaller.client?.deauthorize()
    //     TwitterAPICaller.client?.fetchRequestToken(withPath: url, method: "GET", callbackURL: URL(string: "alamoTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
    //         let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
    //         UIApplication.shared.open(url)
    //     }, failure: { (error: Error!) -> Void in
    //         print("Error: \(error.localizedDescription)")
    //         self.loginFailure?(error)
    //     })
    // }
    
    func login(url: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        TwitterAPICaller.client?.deauthorize()
        TwitterAPICaller.client?.fetchRequestToken(withPath: url, method: "GET", callbackURL: URL(string: "alamoTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            self.theUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.open(self.theUrl!)
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    
    func logout (){
        // UIApplication.shared.open(theUrl!)
        deauthorize()
        
        // TwitterAPICaller.client?.invalidateToken(success: {
        //     print("Works?")
        // }, failure: { (Error) in
        //     print("Nope. Error: \(Error)")
        // })
        
        // let url = "https://api.twitter.com/1.1/oauth/invalidate_token"
        //
        // TwitterAPICaller.client?.postRequest(url: url, parameters: ["uFTmFW66AAMEUwx3rZlZDMSCf", ], success: {
        //     print("token invalidated")
        // }, failure: { (Error) in
        //     print("token not invalidated")
        // })
        
        
        // let returnStatus = deauthorize()
        // print("Return status: \(returnStatus)")
        // TwitterAPICaller.client?.deauthorize()
        // invalidateToken {
        //     print("invalidate success!")
        // } failure: { (Error) in
        //     print("invalidate failure! Error: \(Error)")
        // }
        // let url = "https://api.twitter.com/1.1/oauth/invalidate_token"
        // if TwitterAPICaller.client != nil && accessToken != nil {
        //     TwitterAPICaller.client?.post(url, parameters: ["access_token":accessToken!, "access_token_secret":secret], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
        //         print("success")
        //     }, failure: { (task: URLSessionDataTask?, error: Error) in
        //         print("failure: \(error)")
        //     })
        // }
        
    }
    
    // func invalidateToken(success: @escaping () -> (), failure: @escaping (Error) -> ()){
    //     let url = "https://api.twitter.com/1.1/oauth/invalidate_token"
    //     TwitterAPICaller.client?.post(url, parameters: ["access_token":accessToken!, "access_token_secret":secret], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
    //         success()
    //     }, failure: { (task: URLSessionDataTask?, error: Error) in
    //         failure(error)
    //     })
    // }
    
    func getDictionaryRequest(url: String, parameters: [String:Any], success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! NSDictionary)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getDictionariesRequest(url: String, parameters: [String:Any], success: @escaping ([NSDictionary]) -> (), failure: @escaping (Error) -> ()){
        print(parameters)
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! [NSDictionary])
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func postRequest(url: String, parameters: [Any], success: @escaping () -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func postTweet(tweetString:String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let url = "https://api.twitter.com/1.1/statuses/update.json"
        TwitterAPICaller.client?.post(url, parameters: ["status":tweetString], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    // func invalidateToken(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
    //     let url = "https://api.twitter.com/oauth2/invalidate_token"
    //     TwitterAPICaller.client?.post(url, parameters: ["access_token":], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
    //         success()
    //     }, failure: { (task: URLSessionDataTask?, error: Error) in
    //         failure(error)
    //     })
    // }
    
    func favoriteTweet(tweetId:Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let url = "https://api.twitter.com/1.1/favorites/create.json"
        TwitterAPICaller.client?.post(url, parameters: ["id":tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func unfavoriteTweet(tweetId:Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let url = "https://api.twitter.com/1.1/favorites/destroy.json"
        TwitterAPICaller.client?.post(url, parameters: ["id":tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func retweet(tweetId:Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        // let url = "https://api.twitter.com/1.1/statuses/retweets/\(tweetId).json"
        let url = "https://api.twitter.com/1.1/statuses/retweet/\(tweetId).json"
        TwitterAPICaller.client?.post(url, parameters: ["id":tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
}
