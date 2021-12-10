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
    
    @State private var token: String = myToken.getToken()
    @State private var showUserOrganizationView = false
    
    @State private var user_name: String = ""
    @State private var user_id: String = ""
    @State private var user_email: String = ""
    
    @State private var org_name: String = ""
    @State private var org_id: String = ""
    @State private var org_slug: String = ""
    
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
            Group {
                Text("User")
                    .font(.headline)
                HStack() {
                    Text("Name").bold()
                    Text(")
                }
                HStack() {
                    Text("ID").bold()
                    Text("placeholder")
                }
                HStack() {
                    Text("Email").bold()
                    Text("placeholder")
                }
                Divider()
                Text("Organization")
                    .font(.headline)
                HStack() {
                    Text("Name").bold()
                    Text("placeholder")
                }
                HStack() {
                    Text("ID").bold()
                    Text("placeholder")
                }
                HStack() {
                    Text("Slug").bold()
                    Text("placeholder")
                }
            }.opacity(showUserOrganizationView ? 1.0 : 0.0)
            Group {
                Spacer()
                HStack() {
                    Button(action: {
                        print("Testing Personal Auth Token")
                        let tempToken: BSGToken = BSGToken.init(token: token)
                        getOrganizations(token: tempToken) {
                            switch $0 {
                            case .success(let orgs):
                                print("Success")
                                showUserOrganizationView = true
                            case let .failure(error):
                                print("Failed")
                                showUserOrganizationView = false
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "pencil.circle")
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
                            Image(systemName: "externaldrive.badge.checkmark")
                            Text("Save")
                        }
                        .padding()
                        .frame(maxWidth:.infinity)
                        .background(BSGPrimaryColors.midnight)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
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
                    .cornerRadius(10)
                }
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
