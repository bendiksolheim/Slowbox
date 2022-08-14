import Foundation

public struct Cell {
    let formatting: Formatting
    let content: Character
    
    public init(_ content: Character,  foreground: Color = .Default, background: Color = .Default) {
        self.content = content
        self.formatting = Formatting(foreground, background)
    }
    
    public init(_ content: Character, formatting: Formatting = Formatting(.Default, .Default)) {
        self.content = content
        self.formatting = formatting
    }

    public func with(content: Character? = nil, foreground: Color? = nil, background: Color? = nil) -> Cell {
        let modifiedForeground: Color
        if let foreground = foreground {
            modifiedForeground = foreground
        } else {
            modifiedForeground = self.formatting.foreground.color()
        }
        let modifiedBackground: Color
        if let background = background {
            modifiedBackground = background
        } else {
            modifiedBackground = self.formatting.background.color()
        }

        return Self(content ?? self.content, formatting: Formatting(modifiedForeground, modifiedBackground))
    }
}
