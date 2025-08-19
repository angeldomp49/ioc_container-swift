import Foundation

public protocol PropertyLoader {
    func loadProperties(fileUrl: String, consumer: PropertiesConsumer) -> Void
}

public protocol PropertiesConsumer {
    func consume(_ properties: [String: String])
}

public class JSONPropertyLoader: PropertyLoader {

    
    public func loadProperties(fileUrl: String, consumer: PropertiesConsumer) {
        
        let data = try Data(contentsOf: fileUrl)
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: String] else {
            throw PropertiesLoadingError("Invalid JSON format in file: \(url.path)")
        }
        
        consumer.consume(json)
    }
    
}

public class PlistPropertyLoader: PropertyLoader {
    
    public func loadProperties(fileUrl: String, consumer: PropertiesConsumer){
        
        let data = try Data(contentsOf: fileUrl)
        
        guard let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: String] else {
            throw PropertiesLoadingError("Invalid Plist format in file: \(url.path)")
        }
        
        consumer.consume(plist)
    }
}


public class PropertiesLoadingError: LocalizedError {
    public let errorDescription: String?
    
    public init(_ errorDescription: String? = nil) {
        self.errorDescription = errorDescription
    }
}
