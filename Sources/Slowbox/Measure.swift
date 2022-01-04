import Foundation
import os.log

public func measure<T>(_ label: String, block: () -> T) -> T {
    let info = ProcessInfo.processInfo
    let start = info.systemUptime
    let result = block()
    let diff = info.systemUptime - start
    os_log("%{public}@", "\(label): \(diff)s")
    
    return result
}
