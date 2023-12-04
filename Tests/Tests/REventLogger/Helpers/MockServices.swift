import Foundation

@testable import REventLogger

final class REventSenderMock: REventLoggerSendable {
    var response: Result<Data, Error> = .failure(REventError.internalServicesNotFound)
    func sendEvents(_ apiUrl: String, events: [REvent], onCompletion: @escaping (Result<Data, Error>) -> Void) {
        onCompletion(response)
    }
}

enum EVentLoggerMockData {
    static let apiKey = "e2io-34nj-70bh-oki8"
    static let apiUrl = "https://mock.eventlogger.end.point"
    static let REventModel = REvent(.critical,
                                    sourceName: "IAM",
                                    sourceVersion: "8.0,0",
                                    errorCode: "400",
                                    errorMessage: "Network Error")
}

enum REventError: Error {
    case internalServicesNotFound
}

extension REventError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .internalServicesNotFound:
            return "Unable to find any internal services for given API Key"
        }
    }
}
