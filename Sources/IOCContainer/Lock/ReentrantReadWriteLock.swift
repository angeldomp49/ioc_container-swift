import Foundation

public class ReentrantReadWriteLock {
    
    private var lock = pthread_rwlock_t()
    
    public init() {
        pthread_rwlock_init(&lock, nil)
    }
    
    public func requestReadLock(_ lockConsumer: () -> Any) -> Any {
        let result: Any
        pthread_rwlock_rdlock(&lock)
        result = lockConsumer()
        pthread_rwlock_unlock(&lock)
        
        return result
    }
    
    public func requestWriteLock(_ lockConsumer: () -> Any) -> Any {
        let result: Any
        pthread_rwlock_wrlock(&lock)
        result = lockConsumer()
        pthread_rwlock_unlock(&lock)
        
        return result
    }
    
}

