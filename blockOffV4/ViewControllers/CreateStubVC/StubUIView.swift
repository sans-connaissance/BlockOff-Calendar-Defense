//
//  StubUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 1/16/23.
//

import SwiftUI

struct StubUIView: View {
    var body: some View {
        Form {
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

struct StubUIView_Previews: PreviewProvider {
    static var previews: some View {
        StubUIView()
    }
}
