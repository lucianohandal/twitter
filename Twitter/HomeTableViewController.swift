//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Luciano Handal on 2/8/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    let myRefreshControl = UIRefreshControl()
    let numberOfTweets: Int! = 20
    
    var tweetArray = [NSDictionary]()

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight =  UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 180
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        loadTweets()
    }
    
    @objc func loadTweets(){
        self.tweetArray.removeAll()
        getTweets()
        self.myRefreshControl.endRefreshing()
    }
    
    func getTweets(){
        let retrieveURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: retrieveURL, parameters: params as [String : Any], success: { (tweets: [NSDictionary]) in
            
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print(Error)
            print("Could not retrieve tweets.")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == tweetArray.count){
            getTweets()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let profilePicURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: profilePicURL!)
        
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        cell.setTweetId(tweetArray[indexPath.row]["id"] as! Int)
        
        return cell
    }

    // MARK: - Table view data source
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
