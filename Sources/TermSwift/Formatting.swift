import Foundation

public struct Formatting: CustomStringConvertible, Equatable {
    let foreground: Layer
    let background: Layer
    
    public init(_ foreground: Color, _ background: Color) {
        self.foreground = .Foreground(foreground)
        self.background = .Background(background)
    }
    
    public var description: String {
        return "\u{001b}[0;\(foreground.description);\(background.description)m"
    }
}

public enum Layer: Equatable {
    case Foreground(Color)
    case Background(Color)
}

public enum Color {
    case Default
    case Black
    case Red
    case Green
    case Yellow
    case Blue
    case Magenta
    case Cyan
    case LightGray
    case DarkGray
    case LightRed
    case LightGreen
    case LightYellow
    case LightBlue
    case LightMagenta
    case LightCyan
    case White
}

extension Layer: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .Foreground(color):
            switch color {
            case .Default:
                return Term.FOREGROUND_DEFAULT
            case .Black:
                return Term.FOREGROUND_BLACK
            case .Red:
                return Term.FOREGROUND_RED
            case .Green:
                return Term.FOREGROUND_GREEN
            case .Yellow:
                return Term.FOREGROUND_YELLOW
            case .Blue:
                return Term.FOREGROUND_BLUE
            case .Magenta:
                return Term.FOREGROUND_MAGENTA
            case .Cyan:
                return Term.FOREGROUND_CYAN
            case .LightGray:
                return Term.FOREGROUND_LIGHT_GRAY
            case .DarkGray:
                return Term.FOREGROUND_DARK_GRAY
            case .LightRed:
                return Term.FOREGROUND_LIGHT_RED
            case .LightGreen:
                return Term.FOREGROUND_LIGHT_GREEN
            case .LightYellow:
                return Term.FOREGROUND_LIGHT_YELLOW
            case .LightBlue:
                return Term.FOREGROUND_LIGHT_BLUE
            case .LightMagenta:
                return Term.FOREGROUND_LIGHT_MAGENTA
            case .LightCyan:
                return Term.FOREGROUND_LIGHT_CYAN
            case .White:
                return Term.FOREGROUND_WHITE
            }
        case let .Background(color):
            switch color {
            case .Default:
                return Term.BACKGROUND_DEFAULT
            case .Black:
                return Term.BACKGROUND_BLACK
            case .Red:
                return Term.BACKGROUND_RED
            case .Green:
                return Term.BACKGROUND_GREEN
            case .Yellow:
                return Term.BACKGROUND_YELLOW
            case .Blue:
                return Term.BACKGROUND_BLUE
            case .Magenta:
                return Term.BACKGROUND_MAGENTA
            case .Cyan:
                return Term.BACKGROUND_CYAN
            case .LightGray:
                return Term.BACKGROUND_LIGHT_GRAY
            case .DarkGray:
                return Term.BACKGROUND_DARK_GRAY
            case .LightRed:
                return Term.BACKGROUND_LIGHT_RED
            case .LightGreen:
                return Term.BACKGROUND_LIGHT_GREEN
            case .LightYellow:
                return Term.BACKGROUND_LIGHT_YELLOW
            case .LightBlue:
                return Term.BACKGROUND_LIGHT_BLUE
            case .LightMagenta:
                return Term.BACKGORUND_LIGHT_MAGENTA
            case .LightCyan:
                return Term.BACKGROUND_LIGHT_CYAN
            case .White:
                return Term.BACKGROUND_WHITE
            }
        }
    }
}
