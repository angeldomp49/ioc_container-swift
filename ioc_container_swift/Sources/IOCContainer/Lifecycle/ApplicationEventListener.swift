import Foundation

public protocol ApplicationEventListener {
    func onReadProperties(context: EnvironmentContext, propertiesLoader: PropertyLoader)
    func onBeansToRegister(context: EnvironmentContext) -> Set<BeanInformation>
    func onBeforeSingletonsCreation(context: EnvironmentContext)
    func onAfterSingletonInstantiation(context:EnvironmentContext, container: IOCContainer)
    func onLoadedApplication(_ container: IOCContainer)
}

public extension ApplicationEventListener {
    func onReadProperties(context: EnvironmentContext, propertiesLoader: PropertyLoader){}
    func onBeansToRegister(context: EnvironmentContext) -> Set<BeanInformation>{return Set<String>()}
    func onBeforeSingletonsCreation(context: EnvironmentContext){}
    func onAfterSingletonInstantiation(context:EnvironmentContext, container: IOCContainer){}
    func onLoadedApplication(_ container: IOCContainer){}

}
