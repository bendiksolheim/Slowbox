import Foundation

public struct Size: Equatable, Hashable, CustomStringConvertible {
    public let width: Int
    public let height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    public var description: String {
        "{width: \(width), height: \(height)}"
    }
}
