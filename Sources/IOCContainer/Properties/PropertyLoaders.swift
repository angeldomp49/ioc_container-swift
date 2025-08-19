import Foundation

public protocol PropertyLoader {
    func load() throws -> [String: Any]
}

public class JSONPropertyLoader: PropertyLoader {
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func load() throws -> [String: Any] {
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw IOCContainerError.propertiesLoading("Invalid JSON format in file: \(url.path)")
        }
        return json
    }
}

public class PlistPropertyLoader: PropertyLoader {
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func load() throws -> [String: Any] {
        let data = try Data(contentsOf: url)
        guard let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            throw IOCContainerError.propertiesLoading("Invalid Plist format in file: \(url.path)")
        }
        return plist
    }
}

public class EnvironmentPropertyLoader: PropertyLoader {
    private let prefix: String
    
    public init(prefix: String = "") {
        self.prefix = prefix
    }
    
    public func load() throws -> [String: Any] {
        var properties: [String: Any] = [:]
        let environment = ProcessInfo.processInfo.environment
        
        for (key, value) in environment {
            if prefix.isEmpty || key.hasPrefix(prefix) {
                let finalKey = prefix.isEmpty ? key : String(key.dropFirst(prefix.count))
                properties[finalKey] = value
            }
        }
        
        return properties
    }
}
