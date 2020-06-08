import SimpleFunctional
import SwiftUI
import UIKit

final class ViewIOHandler: IOHandling {
    
    typealias IOType = ViewIO
    
    func handle(output: IOType.Output, inputClosure: @escaping (IOType.Input) -> Void) {
        DispatchQueue.main.async {
            switch output {
            case .listenToViewEvents: self.viewModel.tapFetchClosure = { inputClosure(.didTapFetch(zip: $0)) }
            case .updateFetchButton(let enabled): self.viewModel.isFetchButtonEnabled = enabled
            case .displayLoadingMessage: self.viewModel.isLoading = true
            case .displayWeather(let weather):
                self.viewModel.isLoading = false
                self.viewModel.weather = weather ?? ""
            }
        }
    }
    
    // MARK: - Private
    
    private lazy var viewModel: ContentView.ViewModel = {
        guard let rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UIHostingController<ContentView> else { fatalError() }
        return rootVC.rootView.viewModel
    }()
}
