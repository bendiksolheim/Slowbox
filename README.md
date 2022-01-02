# TermSwift

*Disclaimer: you should probably not use this for anything at all. I have no idea where it works, or if it works. Terminals are hard, man..*

Somewhat low level access to controlling your terminal and using it to make TUIs and what not. Highly inspired by [termbox](https://github.com/nsf/termbox), but tries to mostly use pure Swift library and code.

## Usage

Launch to alternate screen and poll for events

```Swift
let terminal = Terminal(io: TTY(), screen: .Alternate)

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
let terminal = Terminal(io: TTY(), screen: .Alternate)
Array("Hello, World!").enumerated().forEach { c in
  terminal.put(x: item.offset, y: 0, cell: Cell($0))
}
terminal.present()
```

Clean up on exit

```Swift
let terminal = Terminal(io: TTY(), screen: .Alternate)

// Do your thing here

terminal.restore()
```
