import Foundation

public class IOCContainer {
    private let beansLock = ReentrantReadWriteLock()
    var beans: [BeanInformation] = []
    let context: EnvironmentContext
    
    public init(context: EnvironmentContext){
        self.context = context
    }
    
    public func executeDependencyRevision(beanInformation: BeanInformation, consumer: () -> Void = {}){
        
    }
    
    public func addSingleton(identifier: String, instance: Any){
        
    }
}
