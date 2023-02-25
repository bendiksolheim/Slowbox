import Foundation

public struct Rectangle: CustomStringConvertible {
    public let x: Int
    public let y: Int
    public let width: Int
    public let height: Int
    
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    public init(size: Size) {
        self.x = 0
        self.y = 0
        self.width = size.width
        self.height = size.height
    }
    
    public static func empty() -> Rectangle {
        Rectangle(x: 0, y: 0, width: 0, height: 0)
    }
    
    public func with(x: Int? = nil, y: Int? = nil, width: Int? = nil, height: Int? = nil) -> Rectangle {
        Self(x: x ?? self.x, y: y ?? self.y, width: width ?? self.width, height: height ?? self.height)
    }
    
    public var description: String {
        "{x: \(x), y: \(y), width: \(width), height: \(height)}"
    }
}
