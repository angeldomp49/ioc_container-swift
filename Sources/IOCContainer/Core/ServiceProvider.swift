import Foundation

public protocol ServiceProvider {
    func build(_ args: [Any]) throws -> Any
}

public class BeanInformation {
    let identifier: String
    let scope: InstanceScope
    let provider: ServiceProvider
    let dependsOn: Set<String>
    
    public init(identifier: String, scope: InstanceScope, provider: ServiceProvider, dependsOn: Set<String> = []) {
        self.identifier = identifier
        self.scope = scope
        self.provider = provider
        self.dependsOn = dependsOn
    }
}
