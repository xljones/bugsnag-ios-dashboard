//
//  MyAccountView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
import SwiftUI

public struct MyAccountView: View {
    @Environment(\.presentationMode) var thisViewActive
    
    public init() {
    }
    
    public var body: some View {
        Text("My Account details go here")
        Button("Dismiss") {
            self.thisViewActive.wrappedValue.dismiss()
        }
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
