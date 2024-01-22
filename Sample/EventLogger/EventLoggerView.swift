import SwiftUI
import RSDKUtils

protocol EventLogging {
    func logEvent(_ event: EventModel, completionHandler: @escaping ((Bool) -> Void))
    func getStoredEvents() -> [String]
    func getConfiguration() -> (apiKey: String, apiEndpoint: String)
}

struct EventModel {
    let sdkName: String
    let sdkVersion: String
    let errorCode: String
    let errorMessage: String
    let count: Int
    let isCritical: Bool
    let info: String
}

struct EventLoggerView: View {
    private enum Field {
        case sdkName, sdkVersion, errorCode, errorMessage, eventCount
    }
    private enum ErrorMessageType {
        case custom, error1, error2
    }
    private let interactor: EventLogging
    private let defaultErros = DefaultError()

    @State private var sdkName: String = ""
    @State private var sdkVersion: String = ""
    @State private var errorCode: String = ""
    @State private var errorMessage: String = ""
    @State private var customInfo: String = ""
    @State private var eventCount: Int = 1
    @State private var isCritical: Bool = false
    @State private var isLoggingInprogress: Bool = false
    @State private var errorMessageType: ErrorMessageType = .custom
    @State private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    @FocusState private var focusedField: Field?

    init(interactor: EventLogging) {
        self.interactor = interactor
        let appConfig = interactor.getConfiguration()
        REventLogger.shared.configure(apiKey: appConfig.apiKey, apiUrl: appConfig.apiEndpoint)
    }

    var body: some View {
        let customErrorEnabled = Binding<Bool>(
            get: { errorMessageType == .custom },
            set: { value in
                if value {
                    errorMessageType = .custom
                    errorMessage = ""
                }
            })
        let error1Enabled = Binding<Bool>(
            get: { errorMessageType == .error1 },
            set: { value in
                if value {
                    errorMessageType = .error1
                    errorMessage = defaultErros.error1
                }
            })
        let error2Enabled = Binding<Bool>(
            get: { errorMessageType == .error2 },
            set: { value in
                if value {
                    errorMessageType = .error2
                    errorMessage = defaultErros.error2
                }
            })
        NavigationView {
            ZStack{
                Form {
                    Section(header: Text("Insert Event")) {
                        TextField("Enter SDK Name", text: $sdkName)
                            .focused($focusedField, equals: .sdkName)
                            .submitLabel(.next)
                        TextField("Enter SDK Version", text: $sdkVersion)
                            .focused($focusedField, equals: .sdkVersion)
                            .submitLabel(.next)
                        TextField("Enter Error Code", text: $errorCode)
                            .focused($focusedField, equals: .errorCode)
                            .submitLabel(.next)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Error Message")
                            HStack(content: {
                                Toggle(isOn: customErrorEnabled) {
                                    Text("Custom Error")
                                }
                            })
                            HStack(content: {
                                Toggle(isOn: error1Enabled) {
                                    Text("Error 1")
                                }
                            })
                            HStack(content: {
                                Toggle(isOn: error2Enabled) {
                                    Text("Error 2")
                                }
                            })
                            TextField("Enter Error Message", text: $errorMessage)
                                .focused($focusedField, equals: .errorMessage)
                                .submitLabel(.next)
                        }
                        TextField("Number of times (default is 1)", value: $eventCount, formatter: numberFormatter)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .eventCount)
                            .submitLabel(.next)
                        Toggle(isOn: $isCritical) {
                            Text("Critical Event")
                        }
                        VStack(alignment: .leading) {
                            Text("Enter Custom Info")
                            TextField("{ \"key\": \"value\"}", text: $customInfo)
                        }
                        .padding([.top, .bottom])
                    }
                    .onSubmit {
                        updatedFocusFiled()
                    }

                    Button(action: {
                        isLoggingInprogress = true
                        hideKeyboard()
                        sendEvent()
                    }) {
                        Text(isCritical ? "Log Critical Event" : "Log Warning Event")
                    }
                    .disabled(disableLogEvent())

                    Section {
                        NavigationLink(destination: EventListView(interactor: interactor)
                            .navigationBarTitle("Stored Events")) {
                                Button(action: {
                                    hideKeyboard()
                                }) {
                                    Text("Show Stored Events")
                                }
                            }
                    }
                    .navigationBarTitle("Event Logger")
                }

                if isLoggingInprogress { LoaderView() }
            }
            .animation(.default, value: isLoggingInprogress)
        }
    }

    private func disableLogEvent() -> Bool {
        guard !sdkName.isEmpty && !sdkVersion.isEmpty && !errorCode.isEmpty && !errorMessage.isEmpty && isCustomInfoValidJson() else {
            return true
        }
        return false
    }

    private func updatedFocusFiled() {
        switch focusedField {
        case .sdkName:
            focusedField = .sdkVersion
        case .sdkVersion:
            focusedField = .errorCode
        case .errorCode:
            focusedField = .errorMessage
        case .errorMessage:
            focusedField = .eventCount
        case .eventCount:
            hideKeyboard()
        case .none:
            hideKeyboard()
        }
    }

    private func sendEvent() {
        let event = EventModel(sdkName: sdkName, sdkVersion: sdkVersion, errorCode: errorCode, errorMessage: errorMessage, count: eventCount, isCritical: isCritical, info: customInfo)
        interactor.logEvent(event) { isFinished in
            isLoggingInprogress = false
        }
    }

    private func isCustomInfoValidJson() -> Bool {
        if let data = customInfo.data(using: .utf8),
           let _ = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
            return true
        }
        return customInfo.isEmpty ? true : false
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

class DefaultError {
    var error1: String = "Unbale to load realtime error"
    var error2: String = "Unbale to load realtime error"

    init() {
        LoadError1()
        loadError2()
    }

    private func LoadError1() {
        struct Error1Model: Decodable {
            let name: String
            let id: String
        }
        do {
            _ = try JSONDecoder().decode(Error1Model.self, from: "{\"name\":\"EventLogger\"}".data(using: .utf8)!)
        } catch {
            error1 = error.localizedDescription
        }
    }

    private func loadError2() {
        guard let url = URL(string: "https://sampe-eventlogger.com/sample-image") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] _, _, error in
            self?.error2 = error.debugDescription
        }
        task.resume()
    }
}

#Preview {
    EventLoggerView(interactor: EventLoggerInteractor())
}
