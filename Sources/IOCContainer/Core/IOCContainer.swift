import Foundation

public class IOCContainer {
    private let beansLock = ReentrantReadWriteLock()
    var beans: Set<BeanInformation> = []
    
    private let singletonLock = ReentrantReadWriteLock()
    let singletons: [String: Any] = [:]
    
    private let dependencyResolutionStrategy = BottomToTopResolutionStrategy()
    let context: EnvironmentContext
    let beanDependencyRevision = BeanDependencyRevision()
    
    public init(context: EnvironmentContext){
        self.context = context
    }
    
    public func registerAllEquivalents(equivalents: [BeanInformationEquivalent]){
        beansLock.requestWriteLock{
            let beans = equivalents.map{ bean in bean.toBeanInformation() }
            
            self.beans = Set(beans)
        }
    }
    
    public func instantiateSingletons(){
        dependencyResolutionStrategy.resolveInstantiation(container: self)
    }
    
    public func executeDependencyRevision(beanInformation: BeanInformation, consumer: () -> Void = {}){
        beanDependencyRevision.
    }
    
    public func addSingleton(identifier: String, instance: Any){
        
    }
}
