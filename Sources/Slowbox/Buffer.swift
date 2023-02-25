import Foundation
import os.log

public class Buffer: Equatable, CustomStringConvertible {
    let size: Size
    var buffer: [Cell]
    
    public init(size: Size) {
        self.size = size
        buffer = Array(repeating: Cell(" "), count: size.width * size.height)
    }
    
    public func put(x: Int, y: Int, cell: Cell) {
        guard x >= 0 && y >= 0
           && x < size.width && y < size.height else {
               return
           }
        
        buffer[y * size.width + x] = cell
    }

    public func modify(x: Int, y: Int, _ fn: (Cell) -> Cell) {
        guard x >= 0 && y >= 0
           && x < size.width && y < size.height else {
              return
           }

        buffer[y * size.width + x] = fn(buffer[y * size.width + x])
    }
    
    public subscript(index: Int) -> Cell {
        get {
            buffer[index]
        }
    }
    
    public func copy(to buffer: Buffer, from: Rectangle, to: Rectangle) {
        os_log("%{public}@", "Copying: \(self.size.description) (\(from.description)) to \(buffer.size.description) (\(to.description))")
        let yDiff = to.y - from.y
        let fromHeight = min(from.height, size.height)
        let fromWidth = min(from.width, size.width)
        (from.y..<(from.y + fromHeight)).forEach { y in
            let row = self.buffer[(y * size.width + from.x)..<(y * size.width + from.x + fromWidth)]
            let replace = ((y + yDiff) * buffer.size.width + to.x)..<((y + yDiff) * buffer.size.width + to.x + fromWidth)
            buffer.buffer.replaceSubrange( replace, with: row )
        }
    }
    
    public static func == (lhs: Buffer, rhs: Buffer) -> Bool {
        return lhs.size == rhs.size
            && lhs.buffer == rhs.buffer
    }
    
    public var description: String {
        buffer.map { $0.content.description }
            .chunked(by: size.width)
            .map { $0.joined() }
            .joined(separator: "\n")
    }
    
}
