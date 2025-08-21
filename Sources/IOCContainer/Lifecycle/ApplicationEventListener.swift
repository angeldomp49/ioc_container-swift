import Foundation

public protocol ApplicationEventListenerParent {
     func onReadProperties(context: EnvironmentContext, propertiesLoader: PlistPropertyLoader)
     func onBeansToRegister(context: EnvironmentContext) -> Set<BeanInformation>
     func onBeforeSingletonsCreation(context: EnvironmentContext)
     func onLoadedApplication(context: EnvironmentContext,container: IOCContainer)
}

public class ApplicationEventListener: ApplicationEventListenerParent, Hashable{
    let uuid: String = UUID().uuidString
    
    
    public static func == (lhs: ApplicationEventListener, rhs: ApplicationEventListener) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    public func onReadProperties(context: EnvironmentContext, propertiesLoader: PlistPropertyLoader){}
    public func onBeansToRegister(context: EnvironmentContext) -> Set<BeanInformation>{return []}
    public func onBeforeSingletonsCreation(context: EnvironmentContext){}
    public func onLoadedApplication(context: EnvironmentContext,container: IOCContainer){}
    
    
    
}

