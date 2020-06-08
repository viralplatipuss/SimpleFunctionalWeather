import Foundation
import SimpleFunctional

final class HTTPIOHandler: IOHandling {
    
    typealias IOType = HTTPIO
    
    func handle(output: IOType.Output, inputClosure: @escaping (IOType.Input) -> Void) {
        switch output {
        case let .request(id, url, method):
            let task = createDataTask(url: url, method: method) { [weak self] in
                inputClosure(.init(id: id, response: $0))
                self?.queue.sync {
                    self?.dataTaskForId[id] = nil
                }
            }
            task.resume()
            queue.sync { dataTaskForId[id] = task }
            
        case let .cancel(id):
            queue.sync {
                dataTaskForId[id]?.cancel()
                dataTaskForId[id] = nil
            }
        }
    }
    
    
    // MARK: - Private
    
    private var dataTaskForId = [UInt: URLSessionDataTask]()
    private let queue = DispatchQueue(label: "HTTPIOHandler.queue")
    
    private func createDataTask(url: URL, method: String, completion: @escaping (IOType.Input.Response) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
        
        return task
    }
}
