//
//  IpfsManager.swift
//  StoreIt
//
//  Created by Romain Gjura on 24/06/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import SwiftIpfsApi

class IpfsManager {
    
    init() {
		let _ = try! IpfsApi(host: "", port: 0)
    }
    
}