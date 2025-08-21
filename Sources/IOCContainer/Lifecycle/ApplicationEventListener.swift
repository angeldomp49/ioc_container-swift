import Foundation

public protocol ApplicationEventListener {
    func onReadProperties(context: EnvironmentContext, propertiesLoader: PlistPropertyLoader)
    func onBeansToRegister(context: EnvironmentContext) -> Set<BeanInformation>
    func onBeforeSingletonsCreation(context: EnvironmentContext)
    func onLoadedApplication(context: EnvironmentContext,container: IOCContainer)
}

public extension ApplicationEventListener {
    func onReadProperties(context: EnvironmentContext, propertiesLoader: PlistPropertyLoader){}
    func onBeansToRegister(context: EnvironmentContext) -> Set<BeanInformation>{return Set.of()}
    func onBeforeSingletonsCreation(context: EnvironmentContext){}
    func onLoadedApplication(context: EnvironmentContext,container: IOCContainer){}
}


