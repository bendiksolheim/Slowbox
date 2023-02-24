# Slowbox

*Disclaimer: you should probably not use this for anything at all. I have no idea where it works, or if it works. Terminals are hard, man..*

Somewhat low level library for making TUIs in Swift. Highly inspired by [termbox](https://github.com/nsf/termbox), but tries to mostly use pure Swift library and code.

## Usage

See tests for more examples on usage.

Launch to alternate screen and poll for events

```Swift
let terminal = Slowbox(io: TTY(), screen: .Alternate)

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
let terminal = Slowbox(io: TTY(), screen: .Alternate)
let buffer = terminal.emptyBuffer()
Array("Hello, World!").enumerated().forEach { c in
  buffer.put(x: item.offset, y: 0, cell: Cell($0))
}
terminal.present(buffer: buffer)
```

Clean up on exit

```Swift
let terminal = Slowbox(io: TTY(), screen: .Alternate)

// Do your thing here

terminal.restore()
```
