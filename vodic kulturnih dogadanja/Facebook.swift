//
//  Facebook.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 20/01/2018.
//  Copyright © 2018 foi. All rights reserved.
//

import Foundation
import FBSDKShareKit

class Facebook: NSObject, SocialShare, FBSDKAppInviteDialogDelegate {
    func share(network: String, link: String, vc: UIViewController) {
        if (network == "Facebook") {
            let content = FBSDKShareLinkContent()
            content.contentURL = URL(string: link)
            let dialog = FBSDKShareDialog()
            dialog.fromViewController = vc
            dialog.shareContent = content
            dialog.mode = FBSDKShareDialogMode.shareSheet
            dialog.show()
        }
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("Did complete sharing..")
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        print("Error tool place in appInviteDialog \(error)")
    }
}
