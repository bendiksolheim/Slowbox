import Darwin.POSIX.termios
import Foundation
import Slowbox

class InMemoryTTY: IO {
    let termSize: Size
    var termOutput = ""
    
    init(size: Size) {
        self.termSize = size
    }
    
    func read(bytes: Int) -> [UInt8] {
        return "a".utf8.map { UInt8($0) }
    }
    
    func enableRawMode() -> termios {
        // Not needed
        return termios()
    }
    
    func restoreMode(mode: termios) {
        // Not needed
    }
    
    func print(_ value: String) {
        termOutput += value
    }
    
    func flush() {
        // Not needed
    }
    
    func size() throws -> Size {
        return termSize
    }
    
    func output() -> String {
        return termOutput.replacingOccurrences(of: "\u{001B}", with: "\\")
    }
    
    func reset() {
        termOutput = ""
    }
    
    func close() throws {
        // Not needed
    }
}
