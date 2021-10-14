import Foundation

public enum Event: Equatable, Hashable {
    case Key(KeyEvent)
    case Resize(Size)
}

public enum KeyEvent: Equatable, Hashable {
    case Char(Character)
    case Special(SpecialKeyEvent)
    case Ctrl(Character)
    
    public static let tab : KeyEvent = .Special(.Tab)
    public static let esc : KeyEvent = .Special(.Esc)
    public static let enter : KeyEvent = .Special(.Enter)
    public static let dollar : KeyEvent = .Char("$")
    public static let question : KeyEvent = .Char("?")
    
    public static let a : KeyEvent = .Char("a")
    public static let b : KeyEvent = .Char("b")
    public static let c : KeyEvent = .Char("c")
    public static let d : KeyEvent = .Char("d")
    public static let e : KeyEvent = .Char("e")
    public static let f : KeyEvent = .Char("f")
    public static let g : KeyEvent = .Char("g")
    public static let h : KeyEvent = .Char("h")
    public static let i : KeyEvent = .Char("i")
    public static let j : KeyEvent = .Char("j")
    public static let k : KeyEvent = .Char("k")
    public static let l : KeyEvent = .Char("l")
    public static let m : KeyEvent = .Char("m")
    public static let n : KeyEvent = .Char("n")
    public static let o : KeyEvent = .Char("o")
    public static let p : KeyEvent = .Char("p")
    public static let q : KeyEvent = .Char("q")
    public static let r : KeyEvent = .Char("r")
    public static let s : KeyEvent = .Char("s")
    public static let t : KeyEvent = .Char("t")
    public static let u : KeyEvent = .Char("u")
    public static let v : KeyEvent = .Char("v")
    public static let w : KeyEvent = .Char("w")
    public static let x : KeyEvent = .Char("x")
    public static let y : KeyEvent = .Char("y")
    public static let z : KeyEvent = .Char("z")
    public static let æ : KeyEvent = .Char("æ")
    public static let ø : KeyEvent = .Char("ø")
    public static let å : KeyEvent = .Char("å")
    
    public static let A : KeyEvent = .Char("A")
    public static let B : KeyEvent = .Char("B")
    public static let C : KeyEvent = .Char("C")
    public static let D : KeyEvent = .Char("D")
    public static let E : KeyEvent = .Char("E")
    public static let F : KeyEvent = .Char("F")
    public static let G : KeyEvent = .Char("G")
    public static let H : KeyEvent = .Char("H")
    public static let I : KeyEvent = .Char("I")
    public static let J : KeyEvent = .Char("J")
    public static let K : KeyEvent = .Char("K")
    public static let L : KeyEvent = .Char("L")
    public static let M : KeyEvent = .Char("M")
    public static let N : KeyEvent = .Char("N")
    public static let O : KeyEvent = .Char("O")
    public static let P : KeyEvent = .Char("P")
    public static let Q : KeyEvent = .Char("Q")
    public static let R : KeyEvent = .Char("R")
    public static let S : KeyEvent = .Char("S")
    public static let T : KeyEvent = .Char("T")
    public static let U : KeyEvent = .Char("U")
    public static let V : KeyEvent = .Char("V")
    public static let W : KeyEvent = .Char("W")
    public static let X : KeyEvent = .Char("X")
    public static let Y : KeyEvent = .Char("Y")
    public static let Z : KeyEvent = .Char("Z")
    public static let Æ : KeyEvent = .Char("Æ")
    public static let Ø : KeyEvent = .Char("Ø")
    public static let Å : KeyEvent = .Char("Å")
    
    public static let CtrlA : KeyEvent = .Ctrl("a")
    public static let CtrlB : KeyEvent = .Ctrl("b")
    public static let CtrlC : KeyEvent = .Ctrl("c")
    public static let CtrlD : KeyEvent = .Ctrl("d")
    public static let CtrlE : KeyEvent = .Ctrl("e")
    public static let CtrlF : KeyEvent = .Ctrl("f")
    public static let CtrlG : KeyEvent = .Ctrl("g")
    public static let CtrlH : KeyEvent = .Ctrl("h")
    public static let CtrlI : KeyEvent = .Ctrl("i")
    public static let CtrlJ : KeyEvent = .Ctrl("j")
    public static let CtrlK : KeyEvent = .Ctrl("k")
    public static let CtrlL : KeyEvent = .Ctrl("l")
    public static let CtrlM : KeyEvent = .Ctrl("m")
    public static let CtrlN : KeyEvent = .Ctrl("n")
    public static let CtrlO : KeyEvent = .Ctrl("o")
    public static let CtrlP : KeyEvent = .Ctrl("p")
    public static let CtrlQ : KeyEvent = .Ctrl("q")
    public static let CtrlR : KeyEvent = .Ctrl("r")
    public static let CtrlS : KeyEvent = .Ctrl("s")
    public static let CtrlT : KeyEvent = .Ctrl("t")
    public static let CtrlU : KeyEvent = .Ctrl("u")
    public static let CtrlV : KeyEvent = .Ctrl("v")
    public static let CtrlW : KeyEvent = .Ctrl("w")
    public static let CtrlX : KeyEvent = .Ctrl("x")
    public static let CtrlY : KeyEvent = .Ctrl("y")
    public static let CtrlZ : KeyEvent = .Ctrl("z")
    
    public func stringValue() -> String {
        switch self {
        case .Char(let c):
            return c.description
        case .Special(let c):
            return c.stringValue()
        case .Ctrl(let c):
            return "Ctrl - " + c.description
        }
    }
}

public enum SpecialKeyEvent: Equatable {
    case Tab
    case Esc
    case Enter
    
    public func stringValue() -> String {
        switch self {
        case .Tab:
            return "Tab"
        case .Esc:
            return "Escape"
        case .Enter:
            return "Enter"
        }
    }
}
