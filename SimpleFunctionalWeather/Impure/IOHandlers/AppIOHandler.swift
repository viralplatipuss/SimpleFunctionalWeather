import Foundation
import SimpleFunctional

final class AppIOHandler: IOHandling {
    
    typealias IOType = AppIO
    
    func handle(output: IOType.Output, inputClosure: @escaping (IOType.Input) -> Void) {
        switch output {
        case .view(let o): return viewHandler.handle(output: o, inputClosure: { inputClosure(.view($0)) })
        case .http(let o): return httpHandler.handle(output: o, inputClosure: { inputClosure(.http($0)) })
        case .timer(let o): return timerHandler.handle(output: o, inputClosure: { inputClosure(.timer($0)) })
        }
    }

    let viewHandler = ViewIOHandler()
    let httpHandler = HTTPIOHandler()
    let timerHandler = TimerIOHandler()
}
