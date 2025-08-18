import Foundation

public class EnvironmentContext {
    private let lock = NSLock()
    private var properties: [String: Any] = [:]
    private var propertyLoaders: [PropertyLoader] = []
    
    public init() {}
    
    public func registerPropertyLoader(_ loader: PropertyLoader) {
        lock.lock()
        defer { lock.unlock() }
        propertyLoaders.append(loader)
    }
    
    public func loadProperties() throws {
        lock.lock()
        defer { lock.unlock() }
        
        for loader in propertyLoaders {
            let newProperties = try loader.load()
            properties.merge(newProperties) { (current, _) in current }
        }
    }
    
    public func getValue<T>(_ key: String) -> T? {
        lock.lock()
        defer { lock.unlock() }
        return properties[key] as? T
    }
    
    public func setValue(_ value: Any, forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        properties[key] = value
    }
    
    public func getRequiredValue<T>(_ key: String) throws -> T {
        lock.lock()
        defer { lock.unlock() }
        
        guard let value = properties[key] as? T else {
            throw IOCContainerError.propertiesLoading("Required value for key '\(key)' not found or has wrong type")
        }
        return value
    }
    
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        properties.removeAll()
        propertyLoaders.removeAll()
    }
}
