public struct BSGOrganization {
    public init(id: String,
                name: String){
        self.id = id
        self.name = name
    }
    var id: String
    var name: String
}

public struct BSGProject {
    public init(id: String, 
                name: String,
                type: String) {
        self.id = id
        self.name = name
        self.type = type
    }
    var id: String
    var name: String
    var type: String
}

public struct BSGError {
    public init(id: String,
                errorClass: String, 
                errorMessage: String,
                errorContext: String,
                userCount: Int,
                eventCount: Int) {
        self.id = id
        self.errorClass = errorClass
        self.errorMessage = errorMessage
        self.errorContext = errorContext
        self.userCount = userCount
        self.eventCount = eventCount
    }
    var id: String
    var errorClass: String
    var errorMessage: String
    var errorContext: String
    var userCount: Int
    var eventCount: Int
}

public struct BSGEvent {
    public init(id: String,
                errorClass: String,
                errorMessage: String,
                errorContext: String) {
        self.id = id
        self.errorClass = errorClass
        self.errorMessage = errorMessage
        self.errorContext = errorContext
    }
    var id: String
    var errorClass: String
    var errorMessage: String
    var errorContext: String
}
