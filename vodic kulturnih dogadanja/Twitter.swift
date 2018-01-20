//
//  Twitter.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 20/01/2018.
//  Copyright © 2018 foi. All rights reserved.
//

import Foundation
import TwitterKit

class Twitter: NSObject, SocialShare {
    func share(network: String, link: String, vc: UIViewController) {
        if (network == "Twitter") {
            if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
                let composer = TWTRComposer()
                composer.setURL(URL(string: link))
                
                composer.show(from: vc, completion: { (result) in
                    if (result == TWTRComposerResult.cancelled) {
                        print("Tweet composition cancelled.")
                    }
                    else {
                        print("Sending tweet.")
                    }
                })
            }
        }
    }
}
