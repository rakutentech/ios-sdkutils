import SwiftUI

struct EventListView: View {
    private var interactor: EventLogging
    @State private var eventList: [String] = []

    init(interactor: EventLogging) {
        self.interactor = interactor
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Total number of Unique Count: \(eventList.count)")
        }
        List(eventList, id: \.self) { item in
            Text(item)
        }
        .onAppear {
            eventList = interactor.getStoredEvents()
        }
    }
}

#Preview {
    EventListView(interactor: EventLoggerInteractor())
}
