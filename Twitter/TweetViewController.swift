//
//  TweetViewController.swift
//  Twitter
//
//  Created by Luciano Handal on 2/18/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBAction func tweet(_ sender: Any) {
        if (tweetTextView.text.isEmpty){
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error) in
            print("Error tweeting:\n\(error)")
            self.dismiss(animated: true, completion: nil)
        })
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
