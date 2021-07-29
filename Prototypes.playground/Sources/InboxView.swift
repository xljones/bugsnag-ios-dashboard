
import SwiftUI

public struct InboxView: View {
    var errors = [
        BSGError.init(errorClass: "class1", errorMessage: "msg1", errorContext: "ctx1", userCount: 1, eventCount: 2),
        BSGError.init(errorClass: "class2", errorMessage: "msg2", errorContext: "ctx2", userCount: 3, eventCount: 4)
    ]
    public init() { }
    
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
        BSGError.init(errorClass: "My Error Class", errorMessage: "My Error Message", errorContext: "My Error Context", userCount: 345, eventCount: 890)
    public init() {
        
    }
    public var body: some View {
        Text(error.errorClass)
    }
}
