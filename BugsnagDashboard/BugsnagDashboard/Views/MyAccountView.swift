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
    
    var previousToken = myToken.getToken()
    
    // MARK: Present @State values used for live values that can be manipulated and auto show up on UI
    @State var testToken: String = myToken.getToken()
    @State var showUserOrganizationView: Bool
    @State var testUser: BSGUser
    @State var testOrganization: BSGOrganization
    
    private enum BSGTokenTestState {
        case CHANGED_AND_UNTESTED
        case CHANGED_AND_TESTED
        case UNCHANGED
    }
    
    /// This needs to be @State because it's in a Struct which is otherwise immutable.
    @State private var tokenTestState: BSGTokenTestState = .UNCHANGED
    
    init() {
        if myUser != nil && myOrganization != nil {
            print("myUser & myOrganization are populated")
            _showUserOrganizationView = State(initialValue: true)
            _testUser = State(initialValue: myUser!)
            _testOrganization = State(initialValue: myOrganization!)
        } else {
            print("myUser is empty")
            _showUserOrganizationView = State(initialValue: false)
            _testUser = State(initialValue: BSGUser.init())
            _testOrganization = State(initialValue: BSGOrganization.init())
        }
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
                    TextField("Authentication token...", text: $testToken)
                }
            Divider()
            Group {
                Text("User")
                    .font(.headline)
                HStack() {
                    Text("Name").bold()
                    Text(testUser.name)
                }
                HStack() {
                    Text("ID").bold()
                    Text(testUser.id)
                }
                HStack() {
                    Text("Email").bold()
                    Text(testUser.email)
                }
                Divider()
                Text("Organization")
                    .font(.headline)
                HStack() {
                    Text("Name").bold()
                    Text(testOrganization.name)
                }
                HStack() {
                    Text("ID").bold()
                    Text(testOrganization.id)
                }
                HStack() {
                    Text("Slug").bold()
                    Text(testOrganization.slug)
                }
            }.opacity(showUserOrganizationView ? 1.0 : 0.1)
            Group {
                Spacer()
                HStack() {
                    Button(action: {
                        print("Testing Personal Auth Token")
                        /// reset these objects to nil so failures are more obvious
                        testUser = BSGUser.init()
                        testOrganization = BSGOrganization.init()
                        tokenTestState = .CHANGED_AND_UNTESTED
                        getUserAndOrganization(testToken: BSGToken.init(token: testToken)) { rtnUser, rtnOrganization in
                            if rtnUser != nil && rtnOrganization != nil {
                                testUser = rtnUser!
                                testOrganization = rtnOrganization!
                                tokenTestState = .CHANGED_AND_TESTED
                                showUserOrganizationView = true
                            } else {
                                tokenTestState = .CHANGED_AND_UNTESTED
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
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        if (testToken != previousToken || myOrganization == nil || myUser == nil) {
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
                            getUserAndOrganization(testToken: BSGToken.init(token: testToken)) { rtnUser, rtnOrganization in
                                if rtnUser != nil && rtnOrganization != nil {
                                    myUser = rtnUser!
                                    myOrganization = rtnOrganization!
                                    print("Save: --> Test passed")
                                    self.thisView.wrappedValue.dismiss()
                                } else {
                                    print("Save: --> Test failed")
                                    tokenTestState = .CHANGED_AND_UNTESTED
                                    showUserOrganizationView = false
                                }
                            }
                        }
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
