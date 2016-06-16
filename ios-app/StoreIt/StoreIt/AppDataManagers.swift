//
//  AppDataManagers.swift
//  StoreIt
//
//  Created by Romain Gjura on 06/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation

enum ConnexionType: String {
    case GOOGLE = "gg"
    case FACEBOOK = "fb"
}

struct AppDataManagers {
    var connexionType: ConnexionType? = nil
    var networkManager: NetworkManager? = nil
    var connexionManager: ConnexionManager? = nil
    var fileManager: FileManager? = nil
    var navigationManager: NavigationManager? = nil
}