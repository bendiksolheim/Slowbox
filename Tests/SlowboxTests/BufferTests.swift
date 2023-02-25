import XCTest
@testable import Slowbox

final class BufferTests: XCTestCase {
    
    func testCopyToWithEqualFromToRects() {
        let b1 = createBuffer(["ab", "cd"])
        let b2 = createBuffer(["  ", "  "])
        b1.copy(to: b2, from: Rectangle(x: 0, y: 0, width: 2, height: 2), to: Rectangle(x: 0, y: 0, width: 2, height: 2))
        
        XCTAssertEqual(b2, createBuffer(["ab", "cd"]))
    }
    
    func testCopyToPartOfBufferSameDestination() {
        let b1 = createBuffer(["aaa", "aaa", "aaa"])
        let b2 = createBuffer(["bbb", "bbb", "bbb"])
        b1.copy(to: b2, from: Rectangle(x: 1, y: 1, width: 1, height: 1), to: Rectangle(x: 1, y: 1, width: 1, height: 1))
        
        XCTAssertEqual(b2, createBuffer(["bbb", "bab", "bbb"]))
    }
    
    func testCopyToPartOfBufferDifferentDestination() {
        let b1 = createBuffer(["aaa", "aaa", "aaa"])
        let b2 = createBuffer(["bbb", "bbb", "bbb"])
        b1.copy(to: b2, from: Rectangle(x: 0, y: 0, width: 2, height: 2), to: Rectangle(x: 1, y: 1, width: 2, height: 2))
        
        XCTAssertEqual(b2, createBuffer(["bbb", "baa", "baa"]))
    }
    
    func testCopyTooLargeRectFromBuffer() {
        let b1 = createBuffer(["aaa", "aaa", "aaa"])
        let b2 = createBuffer(["bbbb", "bbbb", "bbbb", "bbbb"])
        b1.copy(to: b2, from: Rectangle(size: b2.size), to: Rectangle(size: b2.size))
        
        XCTAssertEqual(b2, createBuffer(["aaab", "aaab", "aaab", "bbbb"]))
    }
}

func createBuffer(_ content: [String]) -> Buffer {
    let width = content[0].count
    let height = content.count
    let buffer = Buffer(size: Size(width: width, height: height))
    (0..<height).forEach { y in
        content[y].enumerated().forEach { e in
            buffer.put(x: e.offset, y: y, cell: Cell(e.element))
        }
    }
    
    return buffer
}
