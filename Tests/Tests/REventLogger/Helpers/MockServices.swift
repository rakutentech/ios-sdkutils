import Foundation

#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import REventLogger
#endif

final class REventSenderMock: REventLoggerSendable {
    var response: Result<Data, Error> = .failure(REventError.internalServicesNotFound)
    func sendEvents(_ apiUrl: String, onCompletion: @escaping (Result<Data, Error>) -> Void) {
        onCompletion(response)
    }
}

enum EVentLoggerMockData {
    static let apiKey = "e2io-34nj-70bh-oki8"
    static let apiUrl = "https://mock.eventlogger.end.point"
    static let REventModel = REvent(.critical,
                                    sourceName: "IAM",
                                    sourceVersion: "8.0,0",
                                    errorCode: "500",
                                    errorMessage: "Network Error")
    static let REventModel1 = REvent(.warning,
                                    sourceName: "IAM",
                                    sourceVersion: "8.0,0",
                                    errorCode: "400",
                                    errorMessage: "request sent to the server is invalid")
    static let REventModel2 = REvent(.warning,
                                    sourceName: "PNP",
                                    sourceVersion: "8.0,0",
                                    errorCode: "400",
                                    errorMessage: "request sent to the server is invalid")
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
