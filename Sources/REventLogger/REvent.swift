import Foundation

struct REvent: Codable {
    let eventType: EventType
    let appId: String?
    let appName: String?
    let appVer: String?
    let osVer: String
    let deviceModel: String
    let deviceBrand: String
    let deviceName: String
    let sourceName: String
    let sourceVer: String
    let errorCode: String
    let errorMsg: String
    var eventVer: String = "1"
    var platform: String = "iOS"
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
        appVer = BundleInfo.appVersion
        osVer = DeviceInfo.osVersion
        deviceModel = DeviceInfo.deviceModel
        deviceBrand = DeviceInfo.deviceBrand
        deviceName = DeviceInfo.deviceName
        firstOccurrenceOn = Date().timeIntervalSince1970
        eventType = type
        self.sourceName = sourceName
        self.sourceVer = sourceVersion
        self.errorCode = errorCode
        self.errorMsg = errorMessage
        self.info = info
    }
}
