import Foundation

let ctrlKeys = (UInt8(ascii: "a") ... UInt8(ascii: "z")).map { $0 & 0b0001_1111 }
