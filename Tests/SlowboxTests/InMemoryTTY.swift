import Darwin.POSIX.termios
import Foundation
import Slowbox

class InMemoryTTY: IO {
    let termSize: Size
    var termOutput = ""
    
    init(size: Size) {
        termSize = size
    }
    
    func read(bytes: Int) -> [UInt8] {
        "a".utf8.map {
            UInt8($0)
        }
    }
    
    func enableRawMode() -> termios {
        // Not needed
        termios()
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
        termSize
    }
    
    func output() -> String {
        termOutput.replacingOccurrences(of: "\u{001B}", with: "\\")
    }
    
    func reset() {
        termOutput = ""
    }
    
    func close() throws {
        // Not needed
    }
}
