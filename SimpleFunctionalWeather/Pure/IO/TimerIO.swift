import Foundation
import SimpleFunctional

/// IO to create and listen to timers.
struct TimerIO: IO {
    enum Input {
        case timerFired(id: UInt)
    }
    
    enum Output {
        case addTimer(id: UInt, milliseconds: UInt)
    }
}
