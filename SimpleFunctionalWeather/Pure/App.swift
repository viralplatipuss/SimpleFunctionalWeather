import Foundation
import SimpleFunctional

/**
 Our functional weather app.
 
 This app could be a lot more complex and broken down into sub-apps.
 But as it's a simple example, we simply use a state enum.
 */
struct App: PureAppProviding {
    
    typealias Input = AppIO.Input
    typealias Output = AppIO.Output
    
    init() {
        state = .running
    }
    
    /// Runs the weather app.
    func run(input: Input?) -> (app: Self, outputs: [Output])? {
        guard let input = input else {
            // No input means app just started, begin listening to view events.
            return (self, [.view(.listenToViewEvents)])
        }
        
        // Otherwise, run a different function based on the app's current state.
        switch state {
        case .running: return running(input: input)
        case .loading: return loading(input: input)
        case .waitingBeforeNewFetch: return waitingBeforeNewFetch(input: input)
        }
    }
    
    
    // MARK: - Private
    
    /// An enum representing app state. This could be broken down into multiple structs, each with their own run function, if the app was more complex.
    private enum State {
        /// User can input new weather lookup and displaying a previous weather lookup (if exists).
        case running
        /// App is waiting for the weather API response and showing a loading state.
        case loading
        /// App is waiting for 3 seconds after showing last weather query before re-enabling the fetch button for a new query.
        case waitingBeforeNewFetch
    }
    
    private let state: State
    private let apiRequestID: UInt = 0
    private let timerID: UInt = 0
    
    private init(state: State) {
        self.state = state
    }
    
    private func running(input: Input) -> (app: Self, outputs: [Output])? {
        // Check if the user tapped the fetch button, if so,
        // Change the app to the loading state. Request to display a loading message and disable the fetch button, and request the weather data over http.
        guard case let Input.view(.didTapFetch(zip)) = input else { return nil }
        
        let url = Self.apiURL(zip: zip)
        
        return (App(state: .loading), [.view(.displayLoadingMessage), .view(.updateFetchButton(enabled: false)), .http(.request(id: apiRequestID, url: url, method: "GET"))])
    }
    
    private func loading(input: Input) -> (app: Self, outputs: [Output])? {
        // Check if the http response for the weather has completed.
        // If so, switch to wait state, request to display the weather string (or a generic error message for nil) and set a timer for 3 seconds.
        guard case let Input.http(httpInput) = input, httpInput.id == apiRequestID else { return nil }
        
        let weatherString = httpInput.response.weatherString
        
        return (App(state: .waitingBeforeNewFetch), [.view(.displayWeather(weatherString)), .timer(.addTimer(id: timerID, milliseconds: 3000))])
    }
    
    private func waitingBeforeNewFetch(input: Input) -> (app: Self, outputs: [Output])? {
        // Check if the timer fired. If so, switch the app back to running state and request the fetch button be re-enabled.
        guard case let Input.timer(.timerFired(id)) = input, id == timerID else { return nil }
        
        return (App(state: .running), [.view(.updateFetchButton(enabled: true))])
    }
    
    private static func apiURL(zip: String) -> URL {
        let apiToken = "GET_YOUR_OWN_TOKEN"
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=\(zip),us&units=imperial&appid=\(apiToken)")!
    }
}


// MARK: - Helpers

fileprivate extension HTTPIO.Input.Response {

    /// Hacky substring logic to find needed info. As JSONDecoder is a class & not-pure-functional, and I'm way too lazy to write a whole pure functional JSON parser.
    var weatherString: String? {
        switch self {
        case .failure(_): return nil
        case .success(let data):
            guard let json = data.asUtf8String,
                let desc = json.findStringAfter(string: "\"description\":\"", upToCharacter: "\""),
                let temp = json.findStringAfter(string: "\"temp\":", upToCharacter: ",") else { return nil }
            
            return "\(desc.localizedCapitalized), \(temp)°F"
        }
    }
}

fileprivate extension String {

    func findStringAfter(string: String, upToCharacter character: Character) -> String? {
        let splitStr = components(separatedBy: string)
        guard splitStr.count > 1 else { return nil }
        
        let str = splitStr[1]
        guard let i = str.firstIndex(of: character) else { return nil }
        
        return String(str[str.startIndex ..< i])
    }
}
