

public class PrototypeInformation {
    
    private let identifier: String
    private let provider: PrototypeProvider
    private let dependencies: Set<String>
    
    public init(identifier: String, provider: PrototypeProvider, dependencies: Set<String> = []) {
        self.identifier = identifier
        self.provider = provider
        self.dependencies = dependencies
    }
    
    public func toBeanInformation() -> BeanInformation {
        return BeanInformation(
            identifier: identifier,
            scope: .prototype,
            provider: {(args: [Any]) in
                var context = args[0] as! EnvironmentContext
                var container = args[1] as! IOCContainer
                return self.provider.build(context: context, container: container, args: Array(args.dropFirst(2)))
            }
        )
    }
    
}

public protocol PrototypeProvider {
    
    func build(context: EnvironmentContext, container:IOCContainer, args: [Any]) -> Any

}
