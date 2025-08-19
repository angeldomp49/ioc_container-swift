import Foundation

public enum InstanceScope {
    case singleton
    case prototype
}

public protocol BeanBuilder {
    func build() throws -> Any
}

public struct BeanInformation {
    let identifier: String
    let scope: InstanceScope
    let builder: BeanBuilder
    
    public init(identifier: String, scope: InstanceScope, builder: BeanBuilder) {
        self.identifier = identifier
        self.scope = scope
        self.builder = builder
    }
}

public class SingletonInformation {
    private var instance: Any?
    private let builder: BeanBuilder
    
    init(builder: BeanBuilder) {
        self.builder = builder
    }
    
    func getInstance() throws -> Any {
        if instance == nil {
            instance = try builder.build()
        }
        return instance!
    }
}

public class PrototypeInformation {
    private let builder: BeanBuilder
    
    init(builder: BeanBuilder) {
        self.builder = builder
    }
    
    func getInstance() throws -> Any {
        return try builder.build()
    }
}
