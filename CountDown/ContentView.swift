import SwiftUI
import WidgetKit // Import WidgetKit to reload timelines

struct ContentView: View {
    @AppStorage("targetDate", store: UserDefaults(suiteName: "group.bence.CountDown.batch"))
    private var targetDate: Double = Date().timeIntervalSince1970 // Store date as a Double

    var body: some View {
        VStack {
            DatePicker(
                "Select a date",
                selection: Binding(
                    get: { Date(timeIntervalSince1970: targetDate) },
                    set: {
                        targetDate = $0.timeIntervalSince1970
                        print("Saved Target Date: \(Date(timeIntervalSince1970: targetDate))") // Debugging statement
                        WidgetCenter.shared.reloadTimelines(ofKind: "CountDownWidget") // Reload widget timelines
                    }
                ),
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()

            Text("Days remaining: \(daysRemaining(from: Date(timeIntervalSince1970: targetDate)))")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Crafted in haste but with deep affection for ")
            + Text("Sofia").bold() // This part is bold
            + Text("—to count down the days until we meet again.")
                .font(.body)
                .italic()

        }
        .padding()
    }

    func daysRemaining(from date: Date) -> Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date()) // Start of the current day
        let startOfTargetDay = calendar.startOfDay(for: date) // Start of the target day

        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTargetDay)
        let remaining = components.day ?? 0
        print("Days Remaining in App: \(remaining)") // Debugging statement
        return remaining
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
