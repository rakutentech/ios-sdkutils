import AdSupport.ASIdentifierManager

protocol AdvertisementIdentifiable {
    var advertisingIdentifierUUIDString: String { get }
}

extension ASIdentifierManager: AdvertisementIdentifiable {
    var advertisingIdentifierUUIDString: String {
        advertisingIdentifier.uuidString
    }
}
