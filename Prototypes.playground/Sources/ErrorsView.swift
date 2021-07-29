
import SwiftUI

public struct ErrorsView: View {
    public init() {
        
    }
    
    public var body: some View {
        List {
            Section(header: Text("Today")) {
                ErrorListItem()
                ErrorListItem()
            }
        }
    }
}

struct ErrorListItem: View {
    var error: BSGError = 
        BSGError.init(errorClass: "Class", errorMessage: "Msg", errorContext: "Ctx", userCount: 345, eventCount: 890)
    public init() {
        
    }
    public var body: some View {
        Text(error.errorClass)
    }
}
