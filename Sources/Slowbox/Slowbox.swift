import Foundation
import os.log

public class Slowbox {
    let io: IO
    let originalTerm: termios
    var size: Size
    var resizeHandler: DispatchSourceSignal?
    public var cursor = TerminalCursor(x: 0, y: 0)
    var showCursor = false
    var lastResizeEvent: Size?
    var buffer: [Cell]
    
    public init(io: IO, screen: Screen) {
        self.io = io
        originalTerm = io.enableRawMode()
        size = try! io.size()
        buffer = Array(repeating: Cell(" "), count: size.width * size.height)
        resizeHandler = resizeEvents()
        
        io.print(screen.escapeCode())
        io.flush()
    }

    public func showCursor(_ show: Bool) {
        showCursor = show
    }
    
    public func moveCursor(_ x: Int, _ y: Int) {
        guard x >= 0 && y >= 0
           && x < size.width && y < size.height else {
            return
        }
        
        cursor = TerminalCursor(x: x, y: y)
        io.print(Term.goto(x: x + 1, y: y + 1))
        io.flush()
    }
    
    public func put(x: Int, y: Int, cell: Cell) {
        guard x >= 0 && y >= 0
           && x < size.width && y < size.height else {
               return
           }
        
        buffer[y * size.width + x] = cell
    }
    
    public func present() {
        let currentCursor = TerminalCursor(x: cursor.x, y: cursor.y)
        var format = buffer[0].formatting
        
        let view = format.description + buffer.map { item in
            if item.formatting != format {
                format = item.formatting
                return format.description + String(item.content)
            } else {
                return String(item.content)
            }
        }.chunked(by: size.width)
         .map { $0.joined() }
         .joined(separator: "\r\n")
        
        var output = Term.CURSOR_HIDE
            + Term.CLEAR_SCREEN
            + Term.goto(x: 1, y: 1)
            + view
            + Term.goto(x: currentCursor.x + 1, y: currentCursor.y + 1)

        if showCursor {
            output += Term.CURSOR_SHOW
        }
        
        io.print(output)
        io.flush()
    }
    
    public func terminalSize() -> Size {
        return self.size
    }
    
    public func clearBuffer() {
        self.buffer = Array(repeating: Cell(" "), count: size.width * size.height)
    }
    
    public func restore() {
        io.print(Term.CURSOR_SHOW)
        io.print(Term.MAIN_SCREEN)
        io.flush()
        io.restoreMode(mode: self.originalTerm)
        //try! io.close()
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
        let chars = io.read(bytes: 4)
        return convertBytes(chars, chars.count)
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

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
