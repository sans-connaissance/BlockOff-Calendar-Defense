//
//  ProfileUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 1/14/23.
//

import SwiftUI

struct ProfileUIView: View {
    var dismissAction: (() -> Void)
    
    var body: some View {
        VStack {
            Text("ProfileView")
            Button {
                dismissAction()
                
            } label: {
                Text("Done")
            }
        }
    }
}

struct ProfileUIView_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {   }
        ProfileUIView(dismissAction: dismissAction)
    }
}
