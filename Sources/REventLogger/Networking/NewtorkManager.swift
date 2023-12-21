import Foundation

class NetworkManager {

    private let defaultSession: URLSessionProtocol
    private var dataTask: DataTaskProtocol?

    init(session: URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        defaultSession = session
    }

    func executeRequest(with request: URLRequest, completion: @escaping ((Data?, Error?) -> Void)) {

        dataTask = defaultSession.createURLSessionDataTask(with: request) { data, response, error in

            if let error = error { completion(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse, 200...201 ~= response.statusCode {
                completion(data, nil)
                return
            }
            let errorModel = try? JSONDecoder().decode(APIError.self, from: data ?? Data())
            let serverError = NSError.error(code: (errorModel?.status ?? (response as? HTTPURLResponse)?.statusCode) ?? ErrorCode.unknown,
                                            message: errorModel?.error ?? ErrorMessage.unknown)
            completion(nil, serverError)
        }
        dataTask?.resume()
    }
}
