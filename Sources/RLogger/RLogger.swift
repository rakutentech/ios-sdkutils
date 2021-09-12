import Foundation

public enum RLoggingLevel: Int {
    case verbose, debug, info, warning, error, none
}

/// Log messages for each level: verbose, debug, info, warning, error, none
/// Setting a value to loggingLevel filters the logged messages
public struct RLogger {

    public static var loggingLevel = RLoggingLevel.error

    @discardableResult
    public static func log(_ loggingLevelParam: RLoggingLevel, message: String) -> String? {
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
}

// MARK: - Variadicable

public protocol Variadicable {
    @discardableResult static func verbose(_ format: String, arguments: CVarArg...) -> String?
    @discardableResult static func debug(_ format: String, arguments: CVarArg...) -> String?
    @discardableResult static func info(_ format: String, arguments: CVarArg...) -> String?
    @discardableResult static func warning(_ format: String, arguments: CVarArg...) -> String?
    @discardableResult static func error(_ format: String, arguments: CVarArg...) -> String?
}

extension RLogger: Variadicable {
    @discardableResult public static func verbose(_ format: String, arguments: CVarArg...) -> String? {
        log(.verbose, message: String(format: format, arguments: arguments))
    }
    
    @discardableResult public static func debug(_ format: String, arguments: CVarArg...) -> String? {
        log(.debug, message: String(format: format, arguments: arguments))
    }
    
    @discardableResult public static func info(_ format: String, arguments: CVarArg...) -> String? {
        log(.info, message: String(format: format, arguments: arguments))
    }
    
    @discardableResult public static func warning(_ format: String, arguments: CVarArg...) -> String? {
        log(.warning, message: String(format: format, arguments: arguments))
    }
    
    @discardableResult public static func error(_ format: String, arguments: CVarArg...) -> String? {
        log(.error, message: String(format: format, arguments: arguments))
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
