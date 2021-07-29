
import SwiftUI
import PlaygroundSupport

// Title View contains the title text, project context menu button and account context menu button
struct BugsnagTitle: View {
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
                        .foregroundColor(.white)
                }
                Text("Bugsnag")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                    .font(.title)
                Button(action: {
                    self.showingMyAccountView.toggle()
                }) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                Divider()
            }.frame(width: .infinity, height: 70, alignment: .center)
        }.background(BSGPrimaryColors.midnight)
        
        // When Account view is toggled, show this sheet.
        .sheet(isPresented: $showingMyAccountView) {
            MyAccountView()
        }
    }
}

// The core view of the application
struct CoreView: View { 
    
    let bugsnagDAAToken: String =  "MY_TOKEN"
    var organization = BSGOrganization.init(id: "abcdef1234556788", name: "My Org")
    var projects = [
        BSGProject.init(id: UUID().uuidString, name: "Android", type: "android"),
        BSGProject.init(id: UUID().uuidString, name: "iOS", type: "ios")
    ]
    
    var body: some View {
        BugsnagTitle()
        TabView {
            InboxView()
                .tabItem {
                    Label("Inbox", systemImage:"xmark.octagon")
                }
            TimelineView()
                .tabItem {
                    Label("Timeline", systemImage:"chart.bar.xaxis")
                }
        }.accentColor(BSGSecondaryColors.coral)
    }
}

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Profile")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 100)
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Messages")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Settings")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
    }
}

// Display the CoreView() on the Playgrounds Canvas
PlaygroundPage.current.setLiveView(CoreView())
