import Foundation
import SimpleFunctional

/// ViewIO is highly specific to the weather app.
/// This is because trying to create an IO type for wrapping all of SwiftUI would be a lot of work.
/// For now, this serves our purpose. But makes our code less re-usable on other platforms like Linux.
struct ViewIO: IO {
    enum Input {
        case didTapFetch(zip: String)
    }
    
    enum Output {
        case listenToViewEvents
        case displayLoadingMessage
        case displayWeather(String?)
        case updateFetchButton(enabled: Bool)
    }
}
