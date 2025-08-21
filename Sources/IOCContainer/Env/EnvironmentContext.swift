import OSLog

public class EnvironmentContext{
    
    private let reentrantReadWriteLock = ReentrantReadWriteLock()
    private var items: [String: Any] = [:]
    private let logger = Logger()
    
    public func setItem(key: String, value: Any) {
        
        reentrantReadWriteLock.requestReadLock {
            items[key] = value
        }
        
    }
    
    public func getItem(key: String) -> Any{
        return reentrantReadWriteLock.requestReadLock {
            return items[key]
        }
    }
    
}
