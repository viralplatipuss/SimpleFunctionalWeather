import Foundation
import SimpleFunctional

final class TimerIOHandler: IOHandling {
    
    typealias IOType = TimerIO
    
    func handle(output: IOType.Output, inputClosure: @escaping (IOType.Input) -> Void) {
        guard case let IOType.Output.addTimer(id, milliseconds) = output else { return }
        
        queue.asyncAfter(deadline: .now() + .milliseconds(Int(milliseconds))) {
            inputClosure(.timerFired(id: id))
        }
    }
    
    private let queue = DispatchQueue(label: "TimerIOHandler.queue", attributes: .concurrent)
}
