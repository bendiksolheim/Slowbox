import Foundation

public class Canvas<T> {
    let height: Int
    let width: Int
    var grid: [T]

    init(height: Int, width: Int, defaultValue: T) {
        self.height = height
        self.width = width
        grid = Array(repeating: defaultValue, count: height)
    }

    func indexIsValid(y: Int) -> Bool {
        return y >= 0 && y < height
    }

    public subscript(y: Int) -> T {
        get {
            assert(indexIsValid(y: y), "Index out of range: \(y)")
            return grid[y]
        }
        set {
            assert(indexIsValid(y: y), "Index out of range: \(y)")
            grid[y] = newValue
        }
    }
    
    public func forEach(_ fn: (Int) -> T) {
        for (i, _) in grid.enumerated() {
            self[i] = fn(i)
        }
    }
}
