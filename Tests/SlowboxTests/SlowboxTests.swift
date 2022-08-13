import XCTest
@testable import Slowbox

final class SlowboxTests: XCTestCase {
    func testCanStartApp() {
        let io = InMemoryTTY(size: Size(width: 10, height: 10))
        let term = Slowbox(io: io, screen: .Alternate)
        XCTAssertEqual(term.size, Size(width: 10, height: 10))
    }
    
    func testCanPrint() {
        let io = InMemoryTTY(size: Size(width: 3, height: 1))
        let term = Slowbox(io: io, screen: .Alternate)
        io.reset()
        term.put(x: 0, y: 0, cell: Cell("L"))
        term.put(x: 1, y: 0, cell: Cell("o"))
        term.put(x: 2, y: 0, cell: Cell("l"))
        term.present()
        
        XCTAssertEqual(io.output(), withEscapeCodes(Formatting(.Default, .Default).description + "Lol", term.cursor))
    }
    
    func testCanPrintTwoLines() {
        let io = InMemoryTTY(size: Size(width: 2, height: 2))
        let term = Slowbox(io: io, screen: .Alternate)
        io.reset()
        term.put(x: 0, y: 0, cell: Cell("L"))
        term.put(x: 1, y: 0, cell: Cell("o"))
        term.put(x: 0, y: 1, cell: Cell("l"))
        term.present()
        
        XCTAssertEqual(io.output(), withEscapeCodes(Formatting(.Default, .Default).description + "Lo\r\nl ", term.cursor))
    }
    
    func testSpecifyForegroundAndBackground() {
        let io = InMemoryTTY(size: Size(width: 1, height: 1))
        let term = Slowbox(io: io, screen: .Alternate)
        io.reset()
        term.put(x: 0, y: 0, cell: Cell("a", foreground: .Blue, background: .Cyan))
        term.present()
        
        XCTAssertEqual(io.output(), withEscapeCodes(Formatting(.Blue, .Cyan).description + "a", term.cursor))
    }
    
    func testCanChangeColorMidway() {
        let io = InMemoryTTY(size: Size(width: 2, height: 2))
        let term = Slowbox(io: io, screen: .Alternate)
        io.reset()
        term.put(x: 0, y: 0, cell: Cell("a", foreground: .Blue, background: .Cyan))
        term.put(x: 1, y: 0, cell: Cell("b", foreground: .Blue, background: .Cyan))
        term.put(x: 0, y: 1, cell: Cell("c", foreground: .Red, background: .Black))
        term.put(x: 1, y: 1, cell: Cell("d", foreground: .Red, background: .Black))
        term.present()
        
        XCTAssertEqual(io.output(), withEscapeCodes(Formatting(.Blue, .Cyan).description + "ab\r\n" + Formatting(.Red, .Black).description + "cd", term.cursor))
    }

    static var allTests = [
        ("testCanStartApp", testCanStartApp),
        ("testCanPrint", testCanPrint),
        ("testCanPrintTwoLines", testCanPrintTwoLines),
        ("testSpecifyForegroundAndBackground", testSpecifyForegroundAndBackground),
        ("testCanChangeColorMidway", testCanChangeColorMidway)
    ]
}

func withEscapeCodes(_ view: String, _ currentCursor: TerminalCursor) -> String {
    return (Term.CURSOR_HIDE
        + Term.CLEAR_SCREEN
        + Term.goto(x: 1, y: 1)
        + view.replacingOccurrences(of: "\u{001B}", with: "\\")
        + Term.goto(x: currentCursor.x + 1, y: currentCursor.y + 1)).replacingOccurrences(of: "\u{001B}", with: "\\")
}
