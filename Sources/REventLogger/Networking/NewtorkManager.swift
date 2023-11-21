import Foundation

class NetworkManager {

    private let defaultSession: URLSessionProtocol
    private var dataTask: DataTaskProtocol?

    init(session: URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        defaultSession = session
    }

    func executeRequest(with request: URLRequest, completion: @escaping ((Data?, Error?) -> Void)) {

        dataTask = defaultSession.createDataTask(with: request) { [weak self] data, response, error in

            if let error = error { completion(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse, 200...201 ~= response.statusCode {
                completion(data, nil)
                return
            }
            do {
                let errorModel = try JSONDecoder().decode(APIError.self, from: data ?? Data())
                let serverError = NSError.error(code: errorModel.status, message: errorModel.error)
                completion(nil, serverError)
            } catch {
                let serverError = NSError.error(code: (response as? HTTPURLResponse)?.statusCode ?? ErrorCode.unknown,
                                                message: self?.errorMessage(data) ?? ErrorMessage.unknown)
                return completion(nil, serverError)
            }
        }

        dataTask?.resume()
    }

    private func errorMessage(_ data: Data?) -> String? {
        guard let data = data else {
            return nil
        }
        let dataString = String(data: data, encoding: .utf8)
        if let jsonData = try? JSONSerialization.jsonObject(with: data) as? [AnyHashable: Any] {
            return jsonData["error_description"] as? String
        } else {
            return dataString
        }
    }
}



