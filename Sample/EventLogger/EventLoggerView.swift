import SwiftUI

protocol EventLogging {
    func logEvent(_ event: EventModel)
    func getStoredEvents() -> [String]
}

struct EventModel {
    let sdkName: String
    let sdkVersion: String
    let errorCode: String
    let errorMessage: String
    let count: Int
    let isCritical: Bool
}

struct EventLoggerView: View {
    private enum Field {
        case sdkName, sdkVersion, errorCode, errorMessage, eventCount
    }
    private let interactor: EventLogging

    @State private var sdkName: String = ""
    @State private var sdkVersion: String = ""
    @State private var errorCode: String = ""
    @State private var errorMessage: String = ""
    @State private var eventCount: Int = 1
    @State private var isCritical: Bool = false
    @State private var isLoggingInprogress: Bool = false
    @State private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    @FocusState private var focusedField: Field?

    init(interactor: EventLogging) {
        self.interactor = interactor
    }

    var body: some View {
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
                        TextField("Enter Error Message", text: $errorMessage)
                            .focused($focusedField, equals: .errorMessage)
                            .submitLabel(.next)
                        TextField("Number of items (default is 1)", value: $eventCount, formatter: numberFormatter)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .eventCount)
                            .submitLabel(.next)
                        Toggle(isOn: $isCritical) {
                            Text("Critical Event")
                        }
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
        guard !sdkName.isEmpty && !sdkVersion.isEmpty && !errorCode.isEmpty && !errorMessage.isEmpty else {
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
        let event = EventModel(sdkName: sdkName, sdkVersion: sdkVersion, errorCode: errorCode, errorMessage: errorMessage, count: eventCount, isCritical: isCritical)
        interactor.logEvent(event)
        isLoggingInprogress = false
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

#Preview {
    EventLoggerView(interactor: EventLoggerInteractor())
}
