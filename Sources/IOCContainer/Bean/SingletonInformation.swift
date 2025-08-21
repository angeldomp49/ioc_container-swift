
public class SingletonInformation {
    
    private let identifier: String
    private let provider: SingletonProvider
    private let dependencies: Set<String>
    
    public init(identifier: String, provider: SingletonProvider, dependencies: Set<String> = []) {
        self.identifier = identifier
        self.provider = provider
        self.dependencies = dependencies
    }
    
    public func toBeanInformation() -> BeanInformation {
        return BeanInformation(
            identifier: identifier,
            scope: .prototype
            ){ (args: [Any]) -> Any in
                var context = args[0] as! EnvironmentContext
                var container = args[1] as! IOCContainer
                return self.provider.build(context: context, container: container)
            }
        
    }
    
}

public protocol SingletonProvider{
    func build(context:EnvironmentContext, container:IOCContainer) -> Any
}
