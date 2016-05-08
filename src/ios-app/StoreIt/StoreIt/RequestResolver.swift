//
//  RequestResolver.swift
//  StoreIt
//
//  Created by Romain Gjura on 03/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation

class RequestResolver {
    
    private var REQUEST_NAME = 0
    private var resolver: [String: (String...) -> ()]
    
    init() {
        resolver = [:]
        resolver["JOIN"] = join
    }
    
    func resolve(request: String) {
        var args: [String] = request.componentsSeparatedByString(" ")
        
        if (args.count > 1 && args.contains(args[REQUEST_NAME])) {
            resolver[args[REQUEST_NAME]]?(args.removeFirst())
        } else {
            print("[RequestResolver] Error while resolving request")
        }
    }
    
    private func join(args: String...) {
    	print("[RequestResolver] JOIN")
    }
    
}
