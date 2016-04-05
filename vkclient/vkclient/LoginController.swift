//
//  ViewController.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 07.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import UIKit
import VK_ios_sdk


class LoginController: UIViewController, VKSdkUIDelegate, VKSdkDelegate {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var PERMISSIONS: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PERMISSIONS = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES]
        
        let sdkInstance = VKSdk.initializeWithAppId("5339839")
        sdkInstance.registerDelegate(self as VKSdkDelegate)
        sdkInstance.uiDelegate = self
        VKSdk.wakeUpSession(PERMISSIONS) { (authState, error) -> Void in
            if authState == VKAuthorizationState.Authorized {
                self.goToFeed()
            } else if (error != nil) {
                let alertController = UIAlertController(title: "Error", message: error.description, preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(title: "ok", style: .Cancel, handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func goToFeed() {
        performSegueWithIdentifier("openFeed", sender: self)
    }

    @IBAction func signIn(sender: UIButton) {
        VKSdk.authorize(PERMISSIONS, withOptions: .DisableSafariController)
    }
    
    func vkSdkDidDismissViewController(controller: UIViewController!) {
        
    }
    
    func vkSdkNeedCaptchaEnter(captchaError: VKError!) {
        
    }
    
    func vkSdkShouldPresentViewController(controller: UIViewController!) {
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func vkSdkWillDismissViewController(controller: UIViewController!) {
        
    }
    
    func vkSdkAccessTokenUpdated(newToken: VKAccessToken!, oldToken: VKAccessToken!) {
        
    }
    
    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        if (result.token != nil) {
            print("Login as \(result.user?.first_name)")
            goToFeed()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        
    }
}

