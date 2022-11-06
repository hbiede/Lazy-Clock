//
//  LazyClockWidget.swift
//  LazyClockWidget
//
//  Created by Hundter Biede on 11/5/22.
//  Copyright © 2022 Hundter Biede. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    typealias Entry = LazyClockEntry

    typealias Intent = LazyClockIntent

    func recommendations() -> [IntentRecommendation<LazyClockIntent>] {
        return [IntentRecommendation(intent: Intent(), description: "Current Time")]
    }

    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), configuration: Intent())
    }

    func getSnapshot(
        for configuration: Intent,
        in context: Context,
        completion: @escaping (Entry) -> Void
    ) {
        let entry = Entry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(
        for configuration: Intent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        var entries: [Entry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = Entry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct LazyClockEntry: TimelineEntry {
    let date: Date
    let configuration: LazyClockIntent
}

struct LazyClockWidgetEntryView: View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemLarge:
            VStack {
                Image("WidgetImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(.init(integerLiteral: 12))
                    .padding(EdgeInsets(top: CGFloat(8), leading: .zero, bottom: .zero, trailing: .zero))
                    .accessibilityHidden(true)

                Text(NaturalLanguageTime(entry.date).description)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .padding(EdgeInsets(top: CGFloat(16), leading: .zero, bottom: CGFloat(32), trailing: .zero))

            }
                .padding(.all)
        case .systemMedium, .systemExtraLarge:
            HStack {
                Image("WidgetImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(.init(integerLiteral: 12))
                    .accessibilityHidden(true)

                Text(NaturalLanguageTime(entry.date).description)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(EdgeInsets(top: .zero, leading: CGFloat(8), bottom: .zero, trailing: .zero))
            }
                .padding(.all)
        case .accessoryRectangular:
            Text(NaturalLanguageTime(entry.date).description)
                .multilineTextAlignment(.center)
                .font(.system(size: 500))
                .minimumScaleFactor(0.01)
        default:
            Text(NaturalLanguageTime(entry.date).description)
                .multilineTextAlignment(.center)
        }
    }
}

struct LazyClockWidget: Widget {
    let kind: String = "LazyClockWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: LazyClockIntent.self, provider: Provider()) { entry in
            LazyClockWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(NSLocalizedString("widget-name", comment: "Name of the widget"))
        .description(NSLocalizedString("widget-desc", comment: "Description for the widget"))
        .supportedFamilies([
            .accessoryRectangular,
            .accessoryCircular,
            .accessoryInline,
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .systemExtraLarge
        ])
    }
}

struct LazyClockWidget_Previews: PreviewProvider {
    static var previews: some View {
        LazyClockWidgetEntryView(entry: LazyClockEntry(date: Date(), configuration: LazyClockIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
