import Foundation

public class BeanNotFoundError: LocalizedError{
    private let message: String
    
    public init(_ message: String) {
        self.message = message
    }
}

public class CircularDependencyError: LocalizedError{
    private let message: String
    
    public init(_ message: String) {
        self.message = message
    }
}

public class PropertiesLoadingError: LocalizedError{
    private let message: String
    
    public init(_ message: String) {
        self.message = message
    }
}
