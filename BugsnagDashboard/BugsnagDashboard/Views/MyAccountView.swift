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
    
    @Binding private var myUser: BSGUser?
    @Binding private var myOrganization: BSGOrganization?
    
    private var previousToken = myToken.getToken()
    @State private var testToken: String = myToken.getToken()
    @State private var tokenTestState: BSGTokenTestState = .UNCHANGED /// This needs to be @State because it's in a Struct which is otherwise immutable.
    @State private var testUser: BSGUser?
    @State private var testOrganization: BSGOrganization?
    
    private enum BSGTokenTestState {
        case CHANGED_AND_UNTESTED
        case CHANGED_AND_TESTED
        case UNCHANGED
    }
    
    init(myUser: Binding<BSGUser?>,
         myOrganization: Binding<BSGOrganization?>) {
        _myUser = myUser
        _myOrganization = myOrganization
    }
           
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SheetTitle(title: "My Account")
            VStack(alignment: .leading) {
                HStack() {
                    Text("Personal Authentication Token")
                    Button(action: {
                        openURL(URL(string:"https://bugsnagapiv2.docs.apiary.io/#introduction/authentication")!)
                    }) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(BSGPrimaryColors.indigo)
                    }
                }
                Text("This is your authentication token generated through app.bugnsag.com")
                    .foregroundColor(BSGExtendedColors.batman30)
                    .font(.system(size: 10))
                HStack() {
                    Image(systemName: "key")
                        .foregroundColor(BSGExtendedColors.batman30)
                    TextField("Authentication token...", text: $testToken)
                }
                Divider()
            }.padding(20)
            
            List {
                Section(header: Text("User")) {
                    if let user = testUser {
                        VStack(alignment: .leading) {
                            Text("name").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                            Text(user.name)
                        }
                        VStack(alignment: .leading) {
                            Text("email").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                            Text(user.email)
                        }
                        VStack(alignment: .leading) {
                            Text("id").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                            Text(user.id)
                        }
                    } else {
                        Text("No user information available.")
                            .foregroundColor(BSGExtendedColors.batman40)
                    }
                }
                Section(header: Text("Organization")) {
                    if let organization = testOrganization {
                        VStack(alignment: .leading) {
                            Text("name").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                            Text(organization.name)
                        }
                        VStack(alignment: .leading) {
                            Text("id").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                            Text(organization.id)
                        }
                        VStack(alignment: .leading) {
                            Text("slug").foregroundColor(BSGExtendedColors.batman40).font(.system(size:10))
                            Text(organization.slug)
                        }
                    } else {
                        Text("No organization data available.")
                            .foregroundColor(BSGExtendedColors.batman40)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                testUser = myUser
                testOrganization = myOrganization
            }

            VStack() {
                HStack() {
                    Button(action: {
                        print("Testing Personal Auth Token")
                        /// reset these objects to nil so failures are more obvious
                        tokenTestState = .CHANGED_AND_UNTESTED
                        testUser = nil
                        testOrganization = nil
                        getUserAndOrganization(token: BSGToken.init(token: testToken)) { rtnUser, rtnOrganization in
                            if let user = rtnUser, let organization = rtnOrganization {
                                testUser = user
                                testOrganization = organization
                                tokenTestState = .CHANGED_AND_TESTED
                            } else {
                                tokenTestState = .CHANGED_AND_UNTESTED
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "pencil.circle")
                            Text("Test").bold()
                        }
                        .padding()
                        .frame(maxWidth:.infinity)
                        .background(BSGPrimaryColors.midnight)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        if testToken != previousToken || myOrganization == nil || myUser == nil {
                            tokenTestState = .CHANGED_AND_UNTESTED
                        }
                        switch(tokenTestState) {
                        case .UNCHANGED:
                            print("Save: Not saving token as unchanged")
                            self.thisView.wrappedValue.dismiss()
                        case .CHANGED_AND_TESTED:
                            print("Save: Changing, token was tested so no further testing")
                            myToken.setToken(token: testToken)
                            myUser = testUser
                            myOrganization = testOrganization
                            self.thisView.wrappedValue.dismiss()
                        case .CHANGED_AND_UNTESTED:
                            print("Save: Performing test before saving")
                            getUserAndOrganization(token: BSGToken.init(token: testToken)) { rtnUser, rtnOrganization in
                                if let user = rtnUser, let organization = rtnOrganization {
                                    myUser = user
                                    myOrganization = organization
                                    myToken.setToken(token: testToken)
                                    print("Save: --> Test passed")
                                    self.thisView.wrappedValue.dismiss()
                                } else {
                                    print("Save: --> Test failed")
                                }
                            }
                        }
                    }) {
                        HStack() {
                            Image(systemName: "externaldrive.badge.checkmark")
                            Text("Save").bold()
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
                        Text("Cancel").bold()
                    }
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(BSGSecondaryColors.coral)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                }
            }.padding(20)
        }
    }
}

struct MyAccountView_Previews: PreviewProvider {
    @State static var testUser: BSGUser? // = BSGUser.init(id: "6113b214304caa001430597a", name: "Xander Jones", email: "xander@bugsnag.com")
    @State static var testOrganization: BSGOrganization?
    static var previews: some View {
        MyAccountView(myUser: $testUser, myOrganization: $testOrganization)
    }
}
