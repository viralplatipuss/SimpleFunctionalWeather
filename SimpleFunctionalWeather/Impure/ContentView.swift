import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Welcome to SimpleFunctional Weather. A crappy weather app.")
                .multilineTextAlignment(.center).padding(.horizontal)
                
            HStack {
                Text("US Zip Code:")
                TextField("", text: $zip)
                    .keyboardType(.numberPad)
                    .border(Color.black, width: 1)
                    .disabled(viewModel.isLoading)
            }.padding(.horizontal)
            
            Button(action: didTapFetch, label: { Text("Fetch") })
                .disabled(!viewModel.isFetchButtonEnabled)
                .padding(.bottom)
            
            if viewModel.isLoading {
                Text("Loading...")
            } else {
                if viewModel.weather.isEmpty {
                    Text("Error fetching weather.").foregroundColor(.red)
                } else {
                    Text(viewModel.weather).foregroundColor(.green)
                }
            }
        }
    }
    
    // MARK: - Private
    
    @State private var zip = "90210"
    
    private func didTapFetch() {
        guard !viewModel.isLoading else { return }
        viewModel.tapFetchClosure?(zip)
    }
}

extension ContentView {
    final class ViewModel: ObservableObject {
        
        @Published var weather = " "
        @Published var isLoading = false
        @Published var isFetchButtonEnabled = true
        
        var tapFetchClosure: ((String) -> Void)?
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
