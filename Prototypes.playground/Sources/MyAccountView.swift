import SwiftUI

public struct MyAccountView: View {
    @Environment(\.presentationMode) var thisViewActive
    
    public init() {
    }
    
    public var body: some View {
        Text("My Account details go here")
        Button("Dismiss") {
            self.thisViewActive.wrappedValue.dismiss()
        }
    }
}
