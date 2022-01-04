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
}
