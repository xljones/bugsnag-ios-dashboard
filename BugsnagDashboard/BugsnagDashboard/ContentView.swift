//
//  ContentView.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import SwiftUI

// Title View contains the title text, project context menu button and account context menu button
struct HeaderView: View {
    @State private var showingMyAccountView: Bool = false
    @State private var showingProjectSelectorView: Bool = false
    
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
                        .foregroundColor(BSGPrimaryColors.midnight)
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
                        .foregroundColor(BSGPrimaryColors.midnight)
                }
                Divider()
            }
            .frame(height: 70.0)
            
        }
        .background(BSGExtendedColors.batman10.edgesIgnoringSafeArea(.top))
        
        // When Account view is toggled, show this sheet.
        .sheet(isPresented: $showingMyAccountView) {
            MyAccountView()
        }
        
        // When project selector is toggled, show this sheet.
        .sheet(isPresented: $showingProjectSelectorView) {
            ProjectSelectorView()
        }
    }
}

// The core view of the application
struct ContentView: View {
    
    var body: some View {
        HeaderView()
        TabView {
            OverviewView()
                .tabItem {
                    Label("Overview", systemImage:"circle.grid.cross")
                }
            InboxView()
                .tabItem {
                    Label("Inbox", systemImage:"xmark.octagon")
                }
            TimelineView()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
