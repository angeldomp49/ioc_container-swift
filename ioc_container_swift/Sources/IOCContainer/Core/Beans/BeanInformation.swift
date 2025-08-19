import Foundation

public protocol BeanInformationEquivalent{
    
    BeanInformation toBeanInformation() -> BeanInformation
    
}

public enum InstanceScope {
    case singleton
    case prototype
}

public struct BeanInformation {
    private let identifier: String
    private let scope: InstanceScope
    private let serviceProvider: ServiceProvider
    private let dependencies: [String]
    
    public init(identifier: String, scope: InstanceScope, serviceProvider: ServiceProvider, dependencies: [String]) {
        self.identifier = identifier
        self.scope = scope
        self.builder = builder
        self.dependencies = dependencies
    }
}

public class SingletonInformation : BeanInformationEquivalent{
    private let identifier: String
    private let singletonProvider: SingletoProvider
    private let dependencies: [String]
    
    public init(identifier: String, singletonProvider: SingletoProvider, dependencies: [String]) {
        self.identifier = identifier
        self.singletonProvider = singletonProvider
        self.dependencies = dependencies
    }
    
    func toBeanInformation() -> BeanInformation {
        return BeanInformation(
            identifier: identifier,
            scope: .singleton,
            serviceProvider: args -> {
                let context = args[0] as! EnvironmentContext
                let container = args[1] as! IOCContainer
                return serviceProvider.build(context: context, container: container)
            },
            dependencies: dependencies == nil ? Set<String>() : Set(dependencies!)
        )
    }
    
}

public class PrototypeInformation: BeanInformationEquivalent {
    private let identifier: String
    private let prototypeProvider: PrototypeProvider
    private let dependencies: [String]
    
    public init(identifier: String, prototypeProvider: PrototypeProvider, dependencies: [String]) {
        self.identifier = identifier
        self.prototypeProvider = prototypeProvider
        self.dependencies = dependencies
    }
    
    func toBeanInformation() -> BeanInformation {
        return BeanInformation(
            identifier: identifier,
            scope: .prototype,
            serviceProvider: args -> {
                let context = args[0] as! EnvironmentContext
                let container = args[1] as! IOCContainer
                let _args: [Any] = Array(args[2...])
                prototypeProvider.build(context: context, container: container, _args)
            },
            dependencies: dependencies == nil ? Set<String>() : Set(dependencies!)
    }
}
