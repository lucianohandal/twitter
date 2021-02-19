//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Luciano Handal on 2/8/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var rtButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var favorited:Bool = false
    var retweeted:Bool = false
    var tweetId:Int = -1
    
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if (favorited){
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted:Bool){
        retweeted = isRetweeted
        if (isRetweeted){
            rtButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            rtButton.isEnabled = false
        } else {
            rtButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            rtButton.isEnabled = true
        }
    }
    
    func setTweetId(_ id:Int){
        tweetId = id
    }
 
    @IBAction func retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Error retwitting:\n\(error)")
        })
    }
    
    @IBAction func favorite(_ sender: Any) {
        if (favorited){
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print("Error unfavortiting:\n\(error)")
            })
        } else {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (error) in
                print("Error favortiting:\n\(error)")
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
