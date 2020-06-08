import Foundation
import SimpleFunctional

/// IO for the app, wrapping view, http, and timer.
struct AppIO: IO {
    
    typealias Input = IO<ViewIO.Input, HTTPIO.Input, TimerIO.Input>
    typealias Output = IO<ViewIO.Output, HTTPIO.Output, TimerIO.Output>
    
    enum IO<A, B, C> {
        case view(A)
        case http(B)
        case timer(C)
    }
}
