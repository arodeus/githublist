//
//  GHLUserDetailsViewController.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 22/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import UIKit
import CoreData

extension GHLUserDetailsViewController {
    @IBAction func backToUserList(sender: UIBarButtonItem?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openEmailApp(sender: UIButton) {
        guard let _emailAddress = sender.title(for: .normal) else { return }
        if _emailAddress.isEmpty { return }
        
        if let emailURL = URL(string: "mailto://\(_emailAddress)") {
            // open email outside the current application
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            } else {
                let message = "I was not able to open the default e-mail app"
                let acAlert = UIAlertController(title: "Sorry!", message: message, preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                acAlert.addAction(cancelAction)
                
                self.present(acAlert, animated: true, completion: nil)
            }
        }
    }
}

class GHLUserDetailsViewController: UIViewController {
    var currentItemDetails: GHLItemDetails!
    
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var lblLoginName: UILabel!
    @IBOutlet var lblRealName: UILabel!
    
    @IBOutlet var lblPublicRepo: UILabel!
    @IBOutlet var lblPublicGists: UILabel!
    @IBOutlet var lblFollowers: UILabel!
    @IBOutlet var lblFollowing: UILabel!
    @IBOutlet var txtBio: UITextView!
    @IBOutlet var btnEmail: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.btnEmail.setTitle("E-Mail not available", for: UIControlState.disabled)
        self.lblLoginName.text = ""
        self.lblRealName.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblLoginName.text = self.currentItemDetails.login
        self.lblRealName.text = self.currentItemDetails.name
        self.lblPublicRepo.text = "\(self.currentItemDetails.publicRepos.intValue) Repos"
        self.lblPublicGists.text = "\(self.currentItemDetails.publicRepos.intValue) Gists"
        self.lblFollowers.text = "\(self.currentItemDetails.followers.intValue) Followers"
        self.lblFollowers.text = "\(self.currentItemDetails.following.intValue) Following"
        
        if let _avatarURLString = self.currentItemDetails.avatarURL {
            let imageURL = URL(string: _avatarURLString)
            self.itemImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "no_image_350x350"))
        }
        
        if let _email = self.currentItemDetails.email {
            self.btnEmail.setTitle(_email, for: .normal)
        } else {
            self.btnEmail.isEnabled = false
        }
        
        if let _bio = self.currentItemDetails.bio {
            if !_bio.isEmpty {
                self.txtBio.text = _bio
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
