import Foundation

public class IOCContainer {
    private let context: EnvironmentContext
    private var singletons: [String: SingletonInformation] = [:]
    private var prototypes: [String: PrototypeInformation] = [:]
    private let lock = NSLock()
    private var dependencyGraph: [String: Set<String>] = [:]
    
    public init(context: EnvironmentContext) {
        self.context = context
    }
    
    public func registerBeans(_ beans: Set<BeanInformation>) throws {
        lock.lock()
        defer { lock.unlock() }
        
        // Construir el grafo de dependencias
        for bean in beans {
            dependencyGraph[bean.identifier] = bean.dependsOn
        }
        
        // Verificar dependencias circulares
        try checkForCircularDependencies()
        
        // Registrar los beans
        for bean in beans {
            switch bean.scope {
            case .singleton:
                singletons[bean.identifier] = SingletonInformation(provider: bean.provider)
            case .prototype:
                prototypes[bean.identifier] = PrototypeInformation(provider: bean.provider)
            }
        }
    }
    
    public func instantiateSingletons() throws {
        lock.lock()
        defer { lock.unlock() }
        
        let sortedBeans = try topologicalSort()
        for beanId in sortedBeans {
            if let singleton = singletons[beanId] {
                _ = try singleton.getInstance(container: self)
            }
        }
    }
    
    public func getSingleton<T>(_ identifier: String, _ additionalArgs: Any...) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        guard let singletonInfo = singletons[identifier] else {
            throw IOCContainerError.beanNotFound("Singleton with identifier '\(identifier)' not found")
        }
        
        let instance = try singletonInfo.getInstance(container: self, additionalArgs: additionalArgs)
        guard let typedInstance = instance as? T else {
            throw IOCContainerError.beanNotFound("Bean '\(identifier)' is not of expected type \(T.self)")
        }
        
        return typedInstance
    }
    
    public func getPrototype<T>(_ identifier: String, _ additionalArgs: Any...) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        guard let prototypeInfo = prototypes[identifier] else {
            throw IOCContainerError.beanNotFound("Prototype with identifier '\(identifier)' not found")
        }
        
        let instance = try prototypeInfo.getInstance(container: self, additionalArgs: additionalArgs)
        guard let typedInstance = instance as? T else {
            throw IOCContainerError.beanNotFound("Bean '\(identifier)' is not of expected type \(T.self)")
        }
        
        return typedInstance
    }
    
    private func checkForCircularDependencies() throws {
        var visited = Set<String>()
        var recursionStack = Set<String>()
        
        func dfs(_ node: String) throws {
            visited.insert(node)
            recursionStack.insert(node)
            
            if let dependencies = dependencyGraph[node] {
                for dependency in dependencies {
                    if !visited.contains(dependency) {
                        try dfs(dependency)
                    } else if recursionStack.contains(dependency) {
                        throw IOCContainerError.circularDependency("Circular dependency detected involving '\(node)' and '\(dependency)'")
                    }
                }
            }
            
            recursionStack.remove(node)
        }
        
        for node in dependencyGraph.keys {
            if !visited.contains(node) {
                try dfs(node)
            }
        }
    }
    
    private func topologicalSort() throws -> [String] {
        var visited = Set<String>()
        var sorted = [String]()
        
        func visit(_ node: String) throws {
            visited.insert(node)
            
            if let dependencies = dependencyGraph[node] {
                for dependency in dependencies {
                    if !visited.contains(dependency) {
                        try visit(dependency)
                    }
                }
            }
            
            sorted.append(node)
        }
        
        for node in dependencyGraph.keys {
            if !visited.contains(node) {
                try visit(node)
            }
        }
        
        return sorted.reversed()
    }
    
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        
        singletons.removeAll()
        prototypes.removeAll()
        dependencyGraph.removeAll()
    }
}
