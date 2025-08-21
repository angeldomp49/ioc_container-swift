
public class BottomToTopResolutionStrategy: DependencyResolutionStrategy{
    
    public let lock = ReentrantReadWriteLock()
    
    public func resolveInstantiation(container: IOCContainer) {
        
        do{
            
            try validateAllDependencies(container: container)
            try validateNoCircularDependencies(container: container)
            
        } catch{
            print(error.localizedDescription)
        }
        
        var alreadyInstantiatedIds: Set<String> = []
        
        var noInstantiatedIdsOriginal = container.beans
            .filter{bean in bean.scope == .singleton}
            .map{bean in bean.identifier}
        
        var noInstantiatedIds = Set(noInstantiatedIdsOriginal)
        
        let prototypesOriginal = container.beans
            .filter{bean in bean.scope == .prototype}
            .map{bean in bean.identifier}
        
        let prototypes = Set(prototypesOriginal)
        
        while(!noInstantiatedIds.isEmpty){
            container.beans
                .filter{bean in bean.scope == .singleton}
                .filter{bean in
                    
                    return lock.requestReadLock{
                        
                        let result = canGetBuild(beanInformation: bean, alreadyInstantiatedIds: alreadyInstantiatedIds, prototypes: prototypes)
                        
                        return result as Bool
                    }
                    
                }
                .forEach{ bean in
                    container.executeDependencyRevision(beanInformation: bean) {
                        container.addSingleton(
                            identifier: bean.identifier,
                            instance: bean.provider(container.context, container)
                        )
                    }
                    
                    lock.requestWriteLock{
                        alreadyInstantiatedIds.insert(bean.identifier)
                        noInstantiatedIds.remove(bean.identifier)
                    }
                }
        }
    }
    
    private func canGetBuild(beanInformation: BeanInformation, alreadyInstantiatedIds: Set<String>, prototypes: Set<String>) -> Bool {
        
        if(beanInformation.dependencies.isEmpty){
            return true
        }
        
        return beanInformation.dependencies
            .allSatisfy{ dependencyId in
                alreadyInstantiatedIds.contains(dependencyId) || prototypes.contains(dependencyId)
            }
        
    }
    
    private func validateAllDependencies(container: IOCContainer) throws {
        
        var hasError = false
        var dependencyIdWithError = ""
        
        let allAvailableSingletons = container.beans.map{ bean in bean.identifier }
        
        var deps = container.beans.flatMap{bean in bean.dependencies}
        
        var depsSet = Set(deps)
        
        depsSet.forEach{dependencyId in
            let isUnresolvableDependency = !allAvailableSingletons.contains(dependencyId)
            
            if(isUnresolvableDependency){
                hasError = true
                dependencyIdWithError = dependencyId
            }
        }
            
        
        if(hasError){
            throw BeanNotFoundError("Couldn't find bean for specific ID in dependency resolution: \(dependencyIdWithError)")
        }
        
    }
    
    private func validateNoCircularDependencies(container: IOCContainer) throws {
        
        var hasError = false
        var dependencyIdWithError = ""
        var dependencyIdRelated = ""
        
        container.beans.forEach{ beanInformation in
            beanInformation.dependencies.forEach{ dependencyId in
                let dependencyBean = container.beans.first(where: {beanInformation in beanInformation.identifier == dependencyId})
                let originalId = beanInformation.identifier
                
                if(dependencyBean!.dependencies.contains(originalId)){
                    hasError = true
                    dependencyIdWithError = originalId
                    dependencyIdRelated = dependencyId
                }
            }
        }
        
        if(hasError){
            throw CircularDependencyError("The following bean \(dependencyIdWithError) has circular dependency with \(dependencyIdRelated) bean")
        }
    }
}
