//
//  ProfileUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 1/14/23.
//

import SwiftUI

struct ProfileUIView: View {
    
    var body: some View {
        Form {
            Section("Subscription") {
                Text("Active")
            }
            
            Section("Block Offs") {
                List {
                    Text("Block Off")
                    Text("Work Block")
                    Text("Travel Time")
                    Text("Project Work")
                }
            }
        }
    }
}

struct ProfileUIView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUIView()
    }
}
