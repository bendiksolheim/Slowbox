import Foundation

let ctrlKeys = (UInt8(ascii: "a") ... UInt8(ascii: "z")).map { $0 & 0b0001_1111 }

let specialKeys: Dictionary<UInt8, KeyEvent> = [
    0x09: .tab,
    0x1B: .esc,
    13: .enter
]
