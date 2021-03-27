# TermSwift

*Disclaimer: you should probably not use this for anything at all. I have no idea where it works, or if it works. Terminals are hard, man..*

Somewhat low level access to controlling your terminal and using it to make TUIs and what not. You can see it as a Swift version of [termbox](https://github.com/nsf/termbox). Except that termbox works on cells, and TermSwift right now works on lines.

## Usage

Launch to alternate screen and poll for events

```Swift
let terminal = Terminal(screen: .Alternate)

while true {
  if let event = terminal.poll() {
    switch event {
      case let .Key(keyEvent):
        // Keyboard input
      case let .Resize(newSize):
        // Terminal was resized
    }
  }
}
```

Render stuff

```Swift
let terminal = Terminal(screen: .Alternate)
let buffer = terminal.emptyBuffer<String>()
buffer[0] = "Hello, World!"
terminal.draw(buffer, { $0 })
```

Clean up on exit

```Swift
let terminal = Temrinal(screen: .Alternate)

// Do your thing here

terminal.restore()
```
