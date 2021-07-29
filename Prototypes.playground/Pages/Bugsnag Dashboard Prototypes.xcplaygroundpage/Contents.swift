
import SwiftUI
import PlaygroundSupport

struct Preview: View {
    init() {
        
    }
    
    var body: some View {
        Text("Bugsnag")
        TabView {
            ErrorsView()
                .tabItem {
                    Label("Errors", systemImage:"xmark.octagon")
                }
            TimelineView()
                .tabItem {
                    Label("Timeline", systemImage:"char.bar.xaxis")
                }
        }
    }
}



PlaygroundPage.current.setLiveView(Preview())
