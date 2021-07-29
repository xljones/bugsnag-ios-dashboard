
import SwiftUI
import PlaygroundSupport

let bugsnagDAAToken: String =  "MY_TOKEN"

struct BugsnagTitle: View{
    var body: some View {
        Text("Bugsnag")
            .padding(25)
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundColor(.white)
            .background(BSGPrimaryColors.midnight)
            .font(.title)
    }
}

// The core view of the application
struct CoreView: View {
    init() { }
    
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
            MyAccountView()
                .tabItem {
                    Label("My Account", systemImage:"person.crop.circle")
                }
        }
    }
}

// Display the CoreView() on the Playgrounds Canvas
PlaygroundPage.current.setLiveView(CoreView())
