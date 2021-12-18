//
//  ContentView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import SwiftUI

public var myToken = BSGToken.init()

// The core view of the application
struct ContentView: View {
    @State private var myUser: BSGUser?
    @State private var myOrganization: BSGOrganization?
    @State private var myProjects: [BSGProject]?
    @State private var activeProject: ActiveProject?
    
    var body: some View {
        HeaderView(myUser: $myUser, myOrganization: $myOrganization, myProjects: $myProjects, activeProject: $activeProject)
        TabView {
            OverviewView(activeProject: $activeProject)
                .tabItem {
                    Label("Overview", systemImage:"circle.grid.cross")
                }
            InboxView(activeProject: $activeProject)
                .tabItem {
                    Label("Inbox", systemImage:"xmark.octagon")
                }
            TimelineView(activeProject: $activeProject)
                .tabItem {
                    Label("Timeline", systemImage:"chart.bar.xaxis")
                }
            ReleasesView()
                .tabItem {
                    Label("Releases", systemImage:"shippingbox")
                }
        }
        .accentColor(BSGSecondaryColors.coral)
        .padding(0)
    }
}

// Title View contains the title text, project context menu button and account context menu button
struct HeaderView: View {
    @State private var showingMyAccountView: Bool = false
    @State private var showingProjectSelectorView: Bool = false
    
    @Binding private var myUser: BSGUser?
    @Binding private var myOrganization: BSGOrganization?
    @Binding private var myProjects: [BSGProject]?
    @Binding private var activeProject: ActiveProject?
    
    init(myUser: Binding<BSGUser?>,
         myOrganization: Binding<BSGOrganization?>,
         myProjects: Binding<[BSGProject]?>,
         activeProject: Binding<ActiveProject?>) {
        _myUser = myUser
        _myOrganization = myOrganization
        _myProjects = myProjects
        _activeProject = activeProject
    }
    
    var body: some View {
        // A Stack to present a background color
        ZStack() {
            // A horizontal stack to contain the hamburger, title, and account buttons
            HStack() {
                Divider()
                Button(action: {
                    print("Open the project menu")
                    self.showingProjectSelectorView.toggle()
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 30))
                        .foregroundColor(BSGPrimaryColors.indigo)
                }
                Spacer()
                Image("bugsnag_logo_navy")
                    .resizable()
                    .scaledToFit()
                Spacer()
                Button(action: {
                    self.showingMyAccountView.toggle()
                }) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 30))
                        .foregroundColor(BSGPrimaryColors.indigo)
                }
                Divider()
            }
            .frame(height: 70.0)
            
        }
        .background(BSGExtendedColors.batman00.edgesIgnoringSafeArea(.top))
        // Ignore top safe area to extend the background colour up to the top of screen.
        
        // When Account view is toggled, show this sheet.
        .sheet(isPresented: $showingMyAccountView) {
            MyAccountView(myUser: $myUser, myOrganization: $myOrganization)
        }
        
        // When project selector is toggled, show this sheet.
        .sheet(isPresented: $showingProjectSelectorView) {
            ProjectSelectorView(myProjects: $myProjects, myOrganization: $myOrganization, activeProject: $activeProject)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
