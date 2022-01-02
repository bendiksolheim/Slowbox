import XCTest
@testable import TermSwift

final class TermTests: XCTestCase {
    func testCanStartApp() {
        let io = InMemoryTTY(size: Size(width: 10, height: 10))
        let term = Terminal(io: io, screen: .Alternate)
        XCTAssertEqual(term.size, Size(width: 10, height: 10))
    }
    
    func testCanPrint() {
        let io = InMemoryTTY(size: Size(width: 3, height: 1))
        let term = Terminal(io: io, screen: .Alternate)
        io.reset()
        term.put(x: 0, y: 0, cell: Cell("L"))
        term.put(x: 1, y: 0, cell: Cell("o"))
        term.put(x: 2, y: 0, cell: Cell("l"))
        term.present()
        
        XCTAssertEqual(io.output(), withEscapeCodes(Term.BACKGROUND_DEFAULT + Term.FOREGROUND_DEFAULT + "Lol", term.cursor))
    }
    
    func testCanPrintTwoLines() {
        let io = InMemoryTTY(size: Size(width: 2, height: 2))
        let term = Terminal(io: io, screen: .Alternate)
        io.reset()
        term.put(x: 0, y: 0, cell: Cell("L"))
        term.put(x: 1, y: 0, cell: Cell("o"))
        term.put(x: 0, y: 1, cell: Cell("l"))
        term.present()
        
        XCTAssertEqual(io.output(), withEscapeCodes(Term.BACKGROUND_DEFAULT + Term.FOREGROUND_DEFAULT + "Lo\nl ", term.cursor))
    }
    
    func testSpecifyForegroundAndBackground() {
        let io = InMemoryTTY(size: Size(width: 1, height: 1))
        let term = Terminal(io: io, screen: .Alternate)
        io.reset()
        term.put(x: 0, y: 0, cell: Cell("a", foreground: .Blue, background: .Cyan))
        term.present()
        
        XCTAssertEqual(io.output(), withEscapeCodes(Term.BACKGROUND_CYAN + Term.FOREGROUND_BLUE + "a", term.cursor))
    }
    
    func testCanChangeColorMidway() {
        let io = InMemoryTTY(size: Size(width: 2, height: 2))
        let term = Terminal(io: io, screen: .Alternate)
        io.reset()
        term.put(x: 0, y: 0, cell: Cell("a", foreground: .Blue, background: .Cyan))
        term.put(x: 1, y: 0, cell: Cell("b", foreground: .Blue, background: .Cyan))
        term.put(x: 0, y: 1, cell: Cell("c", foreground: .Red, background: .Black))
        term.put(x: 1, y: 1, cell: Cell("d", foreground: .Red, background: .Black))
        term.present()
        
        XCTAssertEqual(io.output(), withEscapeCodes("\(Term.BACKGROUND_CYAN + Term.FOREGROUND_BLUE)ab\n\(Term.BACKGROUND_BLACK + Term.FOREGROUND_RED)cd", term.cursor))
    }

    static var allTests = [
        ("testCanStartApp", testCanStartApp),
    ]
}

func withEscapeCodes(_ view: String, _ currentCursor: Cursor) -> String {
    return (Term.CURSOR_HIDE
        + Term.CLEAR_SCREEN
        + Term.goto(x: 1, y: 1)
        + view.replacingOccurrences(of: "\u{001B}", with: "\\")
        + Term.goto(x: currentCursor.x + 1, y: currentCursor.y + 1)
        + Term.CURSOR_SHOW).replacingOccurrences(of: "\u{001B}", with: "\\")
}
