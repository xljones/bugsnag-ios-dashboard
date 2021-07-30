//
//  MyAccountView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
import SwiftUI

public struct MyAccountView: View {
    @Environment(\.presentationMode) var thisView
    @Environment(\.openURL) var openURL
    
    @State var token: String = myToken.getToken()
    
    public init() {
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("My Account")
                .font(.title)
            Divider()
            HStack() {
                Text("Personal Authentication Token")
                Button(action: {
                    print("Show help on PAT")
                    openURL(URL(string:"https://bugsnagapiv2.docs.apiary.io/#introduction/authentication")!)
                }) {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(BSGPrimaryColors.indigo)
                }
            }
            Text("This is your authentication token generated through app.bugnsag.com")
                .foregroundColor(BSGExtendedColors.batman30)
                .font(.system(size: 12))
            HStack() {
                Image(systemName: "key")
                    .foregroundColor(BSGExtendedColors.batman30)
                TextField("Authentication token...", text: $token)
            }
            Divider()
            Spacer()
            HStack() {
                Button(action: {
                    print("Testing Personal Auth Token")
                    let tempToken = BSGToken.init(token: token)
                    myOrg = getOrganizations(token: tempToken)
                    print(myOrg)
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Test")
                    }
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(BSGPrimaryColors.midnight)
                    .foregroundColor(Color.white)
                    .cornerRadius(15)
                }
                
                Button(action: {
                    print("Saving new Personal Auth Token")
                    myToken.setToken(token: token)
                    self.thisView.wrappedValue.dismiss()
                }) {
                    HStack() {
                        Image(systemName: "pencil")
                        Text("Save")
                    }
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(BSGPrimaryColors.midnight)
                    .foregroundColor(Color.white)
                    .cornerRadius(15)
                }
            }
            Button(action: {
                print("Cancelling Account update")
                self.thisView.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "xmark.octagon.fill")
                    Text("Cancel")
                }
                .padding()
                .frame(maxWidth:.infinity)
                .background(BSGSecondaryColors.coral)
                .foregroundColor(Color.white)
                .cornerRadius(15)
            }
        }
        .padding(20)
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
