import Foundation

public class PlistPropertyLoader {
    
    public func load(path: String, consumer: @escaping (_ data: Data) -> Void = { _ in return () }) throws {
        let url = URL(string: path)
        let data = try Data(contentsOf: url!)
        guard let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            throw IOCContainerError.propertiesLoading("Invalid Plist format in file: \(url!.path)")
        }
        consumer(data)
    }
}
