import Foundation
#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import Foundation

public protocol IO {
    func read(bytes: Int) -> [UInt8]
    func enableRawMode() -> termios
    func restoreMode(mode: termios)
    func print(_ value: String)
    func flush()
    func size() throws -> Size
    func close() throws
}

public class TTY: IO {
    let tty: FileHandle
    
    public init() {
        tty = FileHandle(forUpdatingAtPath: "/dev/tty")!
    }
    
    public func read(bytes: Int) -> [UInt8] {
        return _read(tty.fileDescriptor, bytes: bytes)
    }
    
    public func enableRawMode() -> termios {
        var raw: termios = initStruct()
        tcgetattr(tty.fileDescriptor, &raw)
        let original = raw
        // Flags for raw mode from https://viewsourcecode.org/snaptoken/kilo/02.enteringRawMode.html
        raw.c_iflag &= ~(UInt(ICRNL | IXON))
        raw.c_lflag &= ~(UInt(ECHO | ICANON | IEXTEN | ISIG))
        raw.c_oflag &= ~(UInt(OPOST))
        raw.c_cc.16 = 0 // VMIN == 16 (minimum bytes to read)
        raw.c_cc.17 = 10 // VTIME == 17 (read timeout in tenth of a second)
        
        tcsetattr(tty.fileDescriptor, TCSAFLUSH, &raw)
        return original
    }
    
    public func restoreMode(mode: termios) {
        var term = mode
        tcsetattr(tty.fileDescriptor, TCSAFLUSH, &term)
    }
    
    public func print(_ value: String) {
        if let data = value.data(using: .utf8) {
            try! tty.write(contentsOf: data)
        }
    }
    
    public func flush() {
        try! tty.synchronize()
    }
    
    public func size() throws -> Size {
        var sz = winsize()
        let success = ioctl(tty.fileDescriptor, TIOCGWINSZ, &sz)
        if success != 0 {
            throw TerminalError.GenericError("Could not get size of terminal window")
        }
        return Size(width: Int(sz.ws_col), height: Int(sz.ws_row))
    }
    
    public func close() throws {
        try tty.close()
    }
}

// https://stackoverflow.com/questions/49748507/listening-to-stdin-in-swift
func initStruct<S>() -> S {
    let struct_pointer = UnsafeMutablePointer<S>.allocate(capacity: 1)
    let struct_memory = struct_pointer.pointee
    struct_pointer.deallocate()
    return struct_memory
}

private func _read(_ fileDescriptor: Int32, bytes: Int) -> [UInt8] {
    var char: [UInt8] = [0, 0, 0, 0]
    let n = read(fileDescriptor, &char, 4)
    return Array(char[0..<n])
}
