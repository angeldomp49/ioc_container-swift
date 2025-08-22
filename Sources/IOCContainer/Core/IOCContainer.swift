import Foundation

public class IOCContainer {
    private let beansLock = ReentrantReadWriteLock()
    var beansInternal: Set<BeanInformation> = []
    
    var beans: Set<BeanInformation>{
        return beansLock.requestReadLock{
            let unmodifiableBeans = Set(beansInternal)
            return unmodifiableBeans
        }
    }
    
    private let singletonLock = ReentrantReadWriteLock()
    var singletons: [String: Any] = [:]
    
    private let dependencyResolutionStrategy = BottomToTopResolutionStrategy()
    let context: EnvironmentContext
    
    private let dependencyRevisionLock = ReentrantReadWriteLock()
    let beanDependencyRevision = BeanDependencyRevision()
    
    public init(context: EnvironmentContext){
        self.context = context
    }
    
    public funct getSi
    
    public func getSingleton(identifier: String) -> Any{
        
    }
    
    public func registerAllEquivalents(equivalents: [BeanInformationEquivalent]){
        beansLock.requestWriteLock{
            let beans = equivalents.map{ bean in bean.toBeanInformation() }
            
            self.beansInternal = Set(beans)
        }
    }
    
    public func instantiateSingletons(){
        dependencyResolutionStrategy.resolveInstantiation(container: self)
    }
    
    public func executeDependencyRevision(beanInformation: BeanInformation, consumer: () -> Void = {}){
        
        dependencyRevisionLock.requestWriteLock{
            beanDependencyRevision.activate(beanInformation: beanInformation)
            consumer()
            beanDependencyRevision.deActivate()
        }
        
    }
    
    public func addSingleton(identifier: String, instance: Any){
        singletonLock.requestWriteLock{
            singletons[identifier] = instance
        }
    }
}
