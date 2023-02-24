import Foundation

public struct Rectangle {
    let x: Int
    let y: Int
    let width: Int
    let height: Int
    
    public static func empty() -> Rectangle {
        Rectangle(x: 0, y: 0, width: 0, height: 0)
    }
    
    public func with(x: Int? = nil, y: Int? = nil, width: Int? = nil, height: Int? = nil) -> Rectangle {
        Self(x: x ?? self.x, y: y ?? self.y, width: width ?? self.width, height: height ?? self.height)
    }
}
