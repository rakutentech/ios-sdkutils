import Foundation

protocol REventLoggerSendable {
    func sendEvents(events: [REvent], onCompletion: @escaping (Result<Data, Error>) -> Void)
    func updateApiConfiguration(_ apiConfiguration: EventLoggerConfiguration)
}

final class REventLoggerSender: REventLoggerSendable {

    private var events: [REvent]?
    private var apiKey: String?
    private var apiConfiguration: EventLoggerConfiguration?
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func updateApiConfiguration(_ apiConfiguration: EventLoggerConfiguration) {
        self.apiConfiguration = apiConfiguration
    }

    func sendEvents(events: [REvent], onCompletion: @escaping (Result<Data, Error>) -> Void) {
        self.events = events

        guard let apiUrl = apiConfiguration?.apiUrl,
              let url = URL(string: apiUrl)
        else {
            onCompletion(.failure(RequestError.invalidURL))
            return
        }

        guard let request = createURLRequest(with: url) else {
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

    var body: Encodable? {
        events
    }

    var path: String {
        "/external/logging/error"
    }

    var method: HTTPMethod {
        .post
    }

    var headers: [String: String]? {
        guard let apiKey = apiConfiguration?.apiKey else { return [REventConstants.RequestHeaderKey.clientApiKey: ""]}
        return [
            REventConstants.RequestHeaderKey.clientApiKey: apiKey
        ]
    }
}
