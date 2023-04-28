//
//  LaunchInfoViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 4/26/23.
//

import CoreData
import Foundation

struct LaunchInfoViewModel {
    let launchInfo: LaunchInfo

    var firstLaunchDate: Date {
        return launchInfo.firstLaunchDate ?? Date.now
    }

    var payWallDate: Date {
        return launchInfo.payWallDate ?? Date.now
    }
    
    var isFirstLaunch: Bool {
        return launchInfo.isFirstLaunch
    }
    
    var showPayWall: Bool {
        return launchInfo.showPayWall
    }
}
