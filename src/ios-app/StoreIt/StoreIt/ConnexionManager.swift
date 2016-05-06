//
//  ConnexionManager.swift
//  StoreIt
//
//  Created by Romain Gjura on 05/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import p2_OAuth2

enum ConnexionType {
    case GOOGLE
    case FACEBOOK
}

typealias OAUTH2 = AnyObject

class ConnexionManager {
    
    let connexionType: ConnexionType
    
    var oauthGoogle: OAuth2CodeGrant? = nil
    var oauthFacebook: OAuth2CodeGrantFacebook? = nil
    
    init(connexionType: ConnexionType) {
        print("[ConnexionManager] Initializing a connexion of type \(connexionType)")
        
        self.connexionType = connexionType
        
        switch connexionType {
            case .GOOGLE:
                oauthGoogle = OAuth2CodeGrant(settings: [
                    "client_id": "929129451297-scre09deafvcfip9tvkefoe590uenv9l.apps.googleusercontent.com",
                    "authorize_uri": "https://accounts.google.com/o/oauth2/auth",
                    "token_uri": "https://www.googleapis.com/oauth2/v3/token",
                    "scope": "profile",
                    "redirect_uris": ["com.googleusercontent.apps.929129451297-scre09deafvcfip9tvkefoe590uenv9l:/oauth-storeit"],
                    ])
            	break
            
            case .FACEBOOK:
                oauthFacebook = OAuth2CodeGrantFacebook(settings: ["":""])
                break
    	}
        
        self.onFailureOrAuthorizeAddEvents()
    }
    
    private func onFailureOrAuthorizeAddEvents() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootController = appDelegate.window?.rootViewController as! UINavigationController
        let loginView = rootController.viewControllers[0] as! LoginView
        
        self.oauthGoogle?.onAuthorize = { parameters in
            print("[ConnexionManager] Did authorize with parameters: \(parameters)")
            loginView.isLogged = true
            loginView.performSegueWithIdentifier("loginSegue", sender: nil)
        }
        self.oauthGoogle?.onFailure = { error in
            if let error = error {
                print("[ConnexionManager] Authorization failure: \(error)")
                loginView.isLogged = false
            }
        }
    }
    
    private func onFailureAddEvents() {

    }
    
    func forgetTokens() {
        switch self.connexionType {
            case .GOOGLE:
                self.oauthGoogle!.forgetTokens()
                break
                
            case .FACEBOOK:
                self.oauthFacebook!.forgetTokens()
                break
            }
    }
    
    func handleRedirectUrl(url: NSURL) {
        switch self.connexionType {
            case .GOOGLE:
                self.oauthGoogle!.handleRedirectURL(url)
                break
                
            case .FACEBOOK:
                self.oauthFacebook!.handleRedirectURL(url)
                break
            }
    }
    
    func authorize(context: AnyObject) {
        switch self.connexionType {
            case .GOOGLE:
                self.oauthGoogle!.authorizeEmbeddedFrom(context)
                break
                
            case .FACEBOOK:
                self.oauthFacebook!.authorizeEmbeddedFrom(context)
                break
        }
    }
    
}