import Foundation

public class ReentrantReadWriteLock {
    
    private var lock = pthread_rwlock_t()
    
    public init() {
        pthread_rwlock_init(&lock, nil)
    }
    
    public func requestReadLock<T>(_ lockConsumer: () -> T) -> T {
        let result: T
        pthread_rwlock_rdlock(&lock)
        result = lockConsumer()
        pthread_rwlock_unlock(&lock)
        
        return result
    }
    
    public func requestWriteLock<T>(_ lockConsumer: () -> T) -> T {
        let result: T
        pthread_rwlock_wrlock(&lock)
        result = lockConsumer()
        pthread_rwlock_unlock(&lock)
        
        return result
    }
    
}

