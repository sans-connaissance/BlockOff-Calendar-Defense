//
//  CheckViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 1/29/23.
//

import Foundation
import CoreData

struct CheckViewModel {
    let check: Check
    
    var ekID: String {
        return check.ekID ?? ""
    }
    
    var title: String {
        return check.title ?? ""
    }
    
}
