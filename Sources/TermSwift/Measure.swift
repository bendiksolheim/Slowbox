import Foundation
import os.log

public func measure(_ label: String, block: () -> Void) {
    let info = ProcessInfo.processInfo
    let start = info.systemUptime
    block()
    let diff = info.systemUptime - start
    os_log("%{public}@", "\(label): \(diff)s")
}
