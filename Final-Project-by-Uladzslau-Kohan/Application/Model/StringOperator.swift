import Foundation

// swiftlint:disable all
postfix operator §
postfix func § (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
