import Foundation

public class ApplicationStructure {
    
    public func initialize(listeners: Set<ApplicationEventListener>){
        let context = EnvironmentContext()
        let container = IOCContainer(context: context)
        let propertiesLoader = PlistPropertyLoader()
        
        let beans = listeners.flatMap{listener in
            return listener.onBeansToRegister(context: context)
        }
        
        listeners.forEach{ listener in
            listener.onReadProperties(context: context, propertiesLoader: propertiesLoader)
        }
        
        container.registerAllEquivalents(beans)
        
        listeners.forEach{ listener in
            listener.onBeforeSingletonsCreation(context: context)
        }
        
        container.instantiateSingletons()
        
        listeners.forEach{ listener in
            listener.onLoadedApplication(context: context, container: container)
        }
    }
    
}
