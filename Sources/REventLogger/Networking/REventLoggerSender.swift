import Foundation

protocol REventLoggerSendable{
    func sendEvents(_ apiUrl: String, events: [REvent], onCompletion: @escaping (Result<Data, Error>) -> Void)
}

struct REventLoggerSender: REventLoggerSendable {
    
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func sendEvents(_ apiUrl: String, events: [REvent],
                  onCompletion: @escaping (Result<Data, Error>) -> Void) {

        guard let url = URL(string: apiUrl) else {
            onCompletion(.failure(RequestError.invalidURL))
            return
        }

        guard let request = createURLRequest(with: url, body: events) else {
            onCompletion(.failure(RequestError.invalidRequest))
            return
        }

        networkManager.executeRequest(with: request) { data, error in
            guard error == nil else {
                onCompletion(.failure(error!))
                return
            }

            guard let responseData = data else {
                onCompletion(.failure(RequestError.noData))
                return
            }
            onCompletion(.success(responseData))
        }
    }
}

extension REventLoggerSender: ConfigureUrlRequest {
    
    var path: String {
        "/external/logging/error"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var header: [String : String]? {
        return [
            REventConsants.RequestHeaderKey.clientApiKey: "apikey" //TODO fetchHeader()
        ]
    }
}
