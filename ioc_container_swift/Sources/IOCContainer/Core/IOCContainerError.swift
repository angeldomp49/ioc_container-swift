import Foundation

public enum IOCContainerError: LocalizedError {
    
    case beanNotFound(String)
    case circularDependency(String)
    case propertiesLoading(String)
    
    public var errorDescription: String? {
        switch self {
        case .beanNotFound(let message):
            return "Bean not found: \(message)"
        case .circularDependency(let message):
            return "Circular dependency detected: \(message)"
        case .propertiesLoading(let message):
            return "Error loading properties: \(message)"
        }
    }
}

