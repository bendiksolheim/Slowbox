import Foundation

public class Buffer {
    let size: Size
    var buffer: [Cell]
    
    init(size: Size) {
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
}
