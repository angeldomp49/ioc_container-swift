import Foundation

public enum InstanceScope {
    case singleton
    case prototype
}

public class BeanInformation {
    let identifier: String
    let scope: InstanceScope
    let provider: (_ args: [Any]) -> Any
    
    public init(identifier: String, scope: InstanceScope, provider: @escaping (_ args: [Any]) -> Any = { _ in return () }) {
        self.identifier = identifier
        self.scope = scope
        self.provider = provider
    }
}
