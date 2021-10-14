import Foundation
import os.log

public class Terminal {
    let fileHandle: FileHandle
    let originalTerm: termios
    var size: Size
    var resizeHandler: DispatchSourceSignal?
    public var cursor = Cursor(x: 0, y: 0)
    var lastResizeEvent: Size?
    
    public init(screen: Screen) {
        self.fileHandle = FileHandle.standardInput
        Term.print(screen.escapeCode())
        Term.flush()
        self.originalTerm = enableRawMode(fileHandle: self.fileHandle)
        self.size = try! Term.size()
        self.resizeHandler = resizeEvents()
    }
    
    public func moveCursor(_ x: Int, _ y: Int) {
        guard x >= 0 && y >= 0
           && x < size.width && y < size.height else {
            return
        }
        
        cursor = Cursor(x: x, y: y)
        Term.print(Term.goto(x: x + 1, y: y + 1))
        Term.flush()
    }
    
    public func draw<T>(_ buffer: [T?], _ toString: (T) -> String) {
        let currentCursor = Cursor(x: cursor.x, y: cursor.y)
        
        let view = Term.CURSOR_HIDE
            + Term.CLEAR_SCREEN
            + Term.goto(x: 1, y: 1)
            + buffer[0..<buffer.count].map {
                if let v = $0 {
                    return toString(v)
                } else {
                    return ""
                }
            }.joined(separator: "\n")
            + Term.goto(x: currentCursor.x + 1, y: currentCursor.y + 1)
            + Term.CURSOR_SHOW
        
        Term.print(view)
        Term.flush()
    }
    
    public func terminalSize() -> Size {
        return self.size
    }
    
    public func clear() {
        Term.print(Term.CLEAR_SCREEN)
        Term.flush()
    }
    
    public func restore() {
        restoreRawMode(fileHandle: self.fileHandle, originalTerm: self.originalTerm)
        Term.print(Term.MAIN_SCREEN)
    }
    
    public func poll() -> Event? {
        if let resizeEvent = lastResizeEvent {
            let ev: Event = .Resize(resizeEvent)
            lastResizeEvent = nil
            return ev
        } else if let c = readEvent() {
            return .Key(c)
        } else {
            return nil
        }
    }
    
    func readEvent() -> KeyEvent? {
        var char: [UInt8] = [0, 0, 0, 0]
        let n = read(self.fileHandle.fileDescriptor, &char, 4)
        return convertBytes(char, n)
    }
    
    func resizeEvents() -> DispatchSourceSignal {
        signal(SIGWINCH, SIG_IGN);
        let q = DispatchQueue(label: "resizequeue")
        let s = DispatchSource.makeSignalSource(signal: SIGWINCH, queue: q)
        s.setEventHandler {
            var w = winsize()
            if ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == 0 {
                let newSize = Size(width: Int(w.ws_col), height: Int(w.ws_row))
                self.lastResizeEvent = newSize
                self.size = Size(width: newSize.width, height: newSize.height)
            }
        }
        s.resume()
        return s
    }
}

func convertBytes(_ bytes: [UInt8], _ n: Int) -> KeyEvent? {
    switch n {
        case 1:
            let byte = bytes[0]
            if let special = specialKeys[byte] {
                return special
            } else if ctrlKeys.contains(byte) {
                return .Ctrl(Character(UnicodeScalar(byte - 0x1 + UInt8(ascii: "a"))))
            } else {
                return .Char(Character(UnicodeScalar(byte)))
            }
        case 2:
            if let c = String(data: Data(bytes: bytes, count: n), encoding: .utf8)?.first {
                return .Char(c)
            } else {
                return nil
            }
        default:
            return nil
    }
}

public struct Size: Equatable, Hashable {
    public let width: Int
    public let height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

// https://stackoverflow.com/questions/49748507/listening-to-stdin-in-swift
func initStruct<S>() -> S {
    let struct_pointer = UnsafeMutablePointer<S>.allocate(capacity: 1)
    let struct_memory = struct_pointer.pointee
    struct_pointer.deallocate()
    return struct_memory
}

func enableRawMode(fileHandle: FileHandle) -> termios {
    var raw: termios = initStruct()
    tcgetattr(fileHandle.fileDescriptor, &raw)
    let original = raw
    // Flags for raw mode from https://viewsourcecode.org/snaptoken/kilo/02.enteringRawMode.html
    raw.c_iflag &= ~(UInt(ICRNL | IXON))
    raw.c_lflag &= ~(UInt(ECHO | ICANON | IEXTEN | ISIG))
    raw.c_cc.16 = 0 // VMIN == 16
    raw.c_cc.17 = 10 // VTIME == 17
    
    tcsetattr(fileHandle.fileDescriptor, TCSAFLUSH, &raw)
    return original
}

func restoreRawMode(fileHandle: FileHandle, originalTerm: termios) {
    var term = originalTerm
    tcsetattr(fileHandle.fileDescriptor, TCSAFLUSH, &term)
}
