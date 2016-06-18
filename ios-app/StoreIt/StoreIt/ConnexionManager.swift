//
//  ConnexionManager.swift
//  StoreIt
//
//  Created by Romain Gjura on 05/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import p2_OAuth2

class ConnexionManager {
    
    let oauth2: OAuth2?
    
    init(connexionType: ConnexionType) {
        print("[ConnexionManager] Initializing a connexion of type \(connexionType)")
        
        switch connexionType {
            case .GOOGLE:
                oauth2 = OAuth2Google()
            	break
            
        	default:
            	oauth2 = nil
                break
    	}
        
        oauth2?.onFailureOrAuthorizeAddEvents()
    }
    
    
    func forgetTokens() {
        oauth2?.forgetTokens()
    }
    
    func handleRedirectUrl(url: NSURL) {
        oauth2?.handleRedirectUrl(url)
    }
    
    func authorize(context: AnyObject) {
        oauth2?.authorize(context)
    }
    
}