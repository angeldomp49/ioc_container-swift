import Foundation

public class SingletonInformation {
    private let idientif
    private var instance: Any?
    private let provider: ServiceProvider
    private let lock = NSLock()
    
    init(provider: ServiceProvider) {
        self.provider = provider
    }
    
    func getInstance(container: IOCContainer, additionalArgs: [Any] = []) throws -> Any {
        lock.lock()
        defer { lock.unlock() }
        
        if instance == nil {
            let args: [Any] = [container] + additionalArgs
            instance = try provider.build(args)
        }
        return instance!
    }
}

public class PrototypeInformation {
    private let provider: ServiceProvider
    private let lock = NSLock()
    
    init(provider: ServiceProvider) {
        self.provider = provider
    }
    
    func getInstance(container: IOCContainer, additionalArgs: [Any] = []) throws -> Any {
        lock.lock()
        defer { lock.unlock() }
        
        let args: [Any] = [container] + additionalArgs
        return try provider.build(args)
    }
}
