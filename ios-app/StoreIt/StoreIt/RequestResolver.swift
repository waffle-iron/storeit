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
    private var resolver: [String: ([String]) -> ()]
    
    init() {
        resolver = [:]
        resolver["JOIN"] = join
        resolver["FDEL"] = fdel
        resolver["FADD"] = fadd
        resolver["FUPT"] = fupt
        resolver["0"] = successResponse
        resolver["1"] = errorResponce
        
    }
    
    func resolve(request: String) {
        var args: [String] = request.componentsSeparatedByString(" ")
        
        if (args.count > 0 && args.contains(args[REQUEST_NAME])) {
            let requestName: String = args[REQUEST_NAME]
            args.removeFirst()
            resolver[requestName]?(args)
        } else {
            print("[RequestResolver] Error while resolving request")
        }
    }
    
    private func join(args: [String]) {
    	print("[RequestResolver] JOIN")
    }
    
    private func fdel(args: [String]) {
        print("[RequestResolver] FDEL")
    }
    
    private func fadd(args: [String]) {
        print("[RequestResolver] FADD")
    }
    
    private func fupt(args: [String]) {
        print("[RequestResolver] FUPT")
    }
    
    private func successResponse(args: [String]) {
        if (args.count > 0) {
            print("[RequestResolver] \(args[0]) request was successful.")
        }
    }
    
    private func errorResponce(args: [String]) {
        if (args.count > 0) {
            print("[RequestResolver] \(args[0]) request went wrong.")
        }
    }
    
}
