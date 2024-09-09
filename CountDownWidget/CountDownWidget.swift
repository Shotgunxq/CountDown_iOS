//
//  CountDownWidget.swift
//  CountDownWidget
//
//  Created by Bence Bodnár on 06/09/2024.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), daysRemaining: 3)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let daysRemaining = calculateDaysRemaining()
        return SimpleEntry(date: Date(), daysRemaining: daysRemaining)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        // Calculate days remaining for the timeline entry
        let daysRemaining = calculateDaysRemaining()

        // Update the timeline at the next midnight
        if let nextMidnight = Calendar.current.nextDate(after: currentDate, matching: DateComponents(hour: 0), matchingPolicy: .strict) {
            let entry = SimpleEntry(date: currentDate, daysRemaining: daysRemaining)
            entries.append(entry)

            // Schedule the next update at midnight
            return Timeline(entries: entries, policy: .after(nextMidnight))
        } else {
            // Fallback update policy if next midnight can't be determined
            let entry = SimpleEntry(date: currentDate, daysRemaining: daysRemaining)
            let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate.addingTimeInterval(3600)
            entries.append(entry)
            return Timeline(entries: entries, policy: .after(nextUpdateDate))
        }
    }

    func calculateDaysRemaining() -> Int {
        guard let targetTimeInterval = UserDefaults(suiteName: "group.bence.CountDown.batch")?.double(forKey: "targetDate"),
              targetTimeInterval > 0 else {
            print("Failed to retrieve or invalid target date.") // Debugging statement
            return 0
        }

        let targetDate = Date(timeIntervalSince1970: targetTimeInterval)
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTargetDay = calendar.startOfDay(for: targetDate)

        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTargetDay)
        let daysRemaining = components.day ?? 0

        print("Target Date in Widget: \(targetDate), Days Remaining: \(daysRemaining)") // Debugging statement
        
        return daysRemaining
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let daysRemaining: Int
}

struct CountDownWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Days Remaining:")
                .font(.headline)
            Text("\(entry.daysRemaining)")
                .font(.largeTitle)
                .bold()
        }
        .padding()
    }
}

struct CountDownWidget: Widget {
    let kind: String = "CountDownWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CountDownWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Countdown Widget")
        .description("This widget shows the days remaining to your selected date.")
    }
}

#Preview(as: .systemSmall) {
    CountDownWidget()
} timeline: {
    SimpleEntry(date: .now, daysRemaining: 10)
    SimpleEntry(date: .now, daysRemaining: 5)
}
