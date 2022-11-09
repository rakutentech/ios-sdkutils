import Foundation

public enum RLoggingLevel: Int {
    case verbose, debug, info, warning, error, none
}

/// Log messages for each level: verbose, debug, info, warning, error, none
/// Setting a value to loggingLevel filters the logged messages
public struct RLogger {

    public static var loggingLevel = RLoggingLevel.error

    @discardableResult
    private static func log(_ loggingLevelParam: RLoggingLevel, message: String) -> String? {
        guard loggingLevel != .none && loggingLevel.rawValue <= loggingLevelParam.rawValue else {
             return nil
         }

         switch loggingLevelParam {
         case .verbose:
 #if DEBUG
             NSLog("🟢 \(RLogger.callerModuleName)(Verbose): %@", message)
 #endif
         case .debug:
 #if DEBUG
             NSLog("🟡 \(RLogger.callerModuleName)(Debug): %@", message)
 #endif
         case .info: NSLog("🔵 \(RLogger.callerModuleName)(Info): %@", message)
         case .warning: NSLog("🟠 \(RLogger.callerModuleName)(Warning): %@", message)
         case .error: NSLog("🔴 \(RLogger.callerModuleName)(Error): %@", message)
         default: ()
         }
         return message
    }

    @discardableResult
    public static func verbose(message: String) -> String? {
        log(.verbose, message: message)
    }

    @discardableResult
    public static func debug(message: String) -> String? {
        log(.debug, message: message)
    }

    @discardableResult
    public static func info(message: String) -> String? {
        log(.info, message: message)
    }

    @discardableResult
    public static func warning(message: String) -> String? {
        log(.warning, message: message)
    }

    @discardableResult
    public static func error(message: String) -> String? {
        log(.error, message: message)
    }
}

internal extension RLogger {
    /// Returns the caller module name.
    ///
    /// - Returns: the caller module name.
    ///   An empty string `""` if the caller module name is not found.
    static var callerModuleName: String {
        let symbols = Thread.callStackSymbols.filter { !$0.contains("RLogger ") }
        guard !symbols.isEmpty else {
            return ""
        }
        let sourceString = symbols[0]
        let separatorSet = CharacterSet(charactersIn: " -[]+?.,")
        let array = sourceString.components(separatedBy: separatorSet).filter { !$0.isEmpty }
        guard array.count > 1 else {
            return ""
        }
        // The index 0 is the current module name
        // The index 1 is the caller module name
        return array[1]
    }
}
