import Foundation
import SimpleFunctional

/// Simple IO for getting data over http.
struct HTTPIO: IO {
    struct Input {
        enum Response {
            case success(Data?)
            case failure(Error)
        }
        
        let id: UInt
        let response: Response
    }
    
    enum Output {
        case request(id: UInt, url: URL, method: String)
        case cancel(id: UInt)
    }
}

