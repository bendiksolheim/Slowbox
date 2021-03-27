import Foundation

public enum Screen {
    case Main
    case Alternate
    
    func escapeCode() -> String {
        switch self {
        case .Alternate:
            return Term.ALTERNATE_SCREEN
        case .Main:
            return Term.MAIN_SCREEN
        }
    }
}
