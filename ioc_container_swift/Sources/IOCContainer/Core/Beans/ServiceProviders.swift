import Foundation

public protocol ServiceProvider {
    func build(_ args: [Any]) -> Any
}

public protocol PrototypeProvider{
    func build(context: EnvironmentContext, container: IOCContainer, _args: [Any])
}

public protocol SingletonProvider{
    func build(context: EnvironmentContext, container: IOCContainer)
}
