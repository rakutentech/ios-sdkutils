import Foundation

struct REvent: Codable {
    let eventType: EventType
    let appId: String?
    let appName: String?
    let appVersion: String?
    let osVersion: String
    let deviceModel: String
    let deviceBrand: String
    let deviceName: String
    let sourceName: String
    let sourceVersion: String
    let errorCode: String
    let errorMessage: String
    let eventVersion: String = "1.0"
    let platform: String = "iOS"
    var occurrenceCount: Int = 0
    var firstOccurrenceOn: Double // unix time
    var info: [String: String]?

    init(_ type: EventType,
         sourceName: String,
         sourceVersion: String,
         errorCode: String,
         errorMessage: String,
         info: [String: String]? = nil) {
        appId = BundleInfo.appId
        appName = BundleInfo.appName
        appVersion = BundleInfo.appVersion
        osVersion = DeviceInfo.osVersion
        deviceModel = DeviceInfo.deviceModel
        deviceBrand = DeviceInfo.deviceBrand
        deviceName = DeviceInfo.deviceName
        firstOccurrenceOn = Date().timeIntervalSince1970
        eventType = type
        self.sourceName = sourceName
        self.sourceVersion = sourceVersion
        self.errorCode = errorCode
        self.errorMessage = errorMessage
        self.info = info
    }
}
