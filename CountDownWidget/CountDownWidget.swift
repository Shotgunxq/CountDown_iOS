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
        SimpleEntry(date: Date(), daysRemaining: 0)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let daysRemaining = calculateDaysRemaining()
        return SimpleEntry(date: Date(), daysRemaining: daysRemaining)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // Calculate days remaining once for the timeline entry
        let daysRemaining = calculateDaysRemaining()

        // Refresh every day at midnight
        let nextUpdateDate = Calendar.current.startOfDay(for: currentDate).addingTimeInterval(86400)
        let entry = SimpleEntry(date: currentDate, daysRemaining: daysRemaining)
        entries.append(entry)
        
        return Timeline(entries: entries, policy: .after(nextUpdateDate))
    }

    func calculateDaysRemaining() -> Int {
        // Retrieve the target date from UserDefaults using App Group
        guard let targetTimeInterval = UserDefaults(suiteName: "group.bence.CountDown")?.double(forKey: "targetDate"),
              targetTimeInterval > 0 else {
            // If no valid target date is set, return 0 or some default value
            print("Failed to retrieve or invalid target date.") // Debugging statement
            return 0
        }

        let targetDate = Date(timeIntervalSince1970: targetTimeInterval)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: targetDate)
        let daysRemaining = components.day ?? 0

        // Debugging print statement to verify the date and calculation
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
