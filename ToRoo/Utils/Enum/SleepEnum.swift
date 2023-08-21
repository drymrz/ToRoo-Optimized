//
//  SleepEnum.swift
//  ToRoo
//
//  Created by Safik Widiantoro on 31/05/23.
//

import Foundation

func date(year: Int, month: Int, day: Int = 1, hour: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minutes, second: seconds)) ?? Date()
}

func calculatePreviousDate(_ currentDate: Date) -> Date {
    let modifiedDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
    return modifiedDate
}

enum SleepStages: String {
    case InBedStage = "In Bed"
    case AwakeStage
    case REMStage
    case DeepStage
    case CoreStage
    case UnspecifiedStage
}

struct SleepEntry: Identifiable, Equatable{
    var id = UUID()
    let startDate: Date
    let endDate: Date
    let sleepStages: String
    let duration: TimeInterval
    
    init(id: UUID = UUID(), startDate: Date, endDate: Date, sleepStages: String, duration: TimeInterval) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.sleepStages = sleepStages
        self.duration = duration
    }
    
    static var allEntries: [SleepEntry] = []
    
    static func getTotalDuration(for entries: [SleepEntry], sleepStage: String) -> TimeInterval {
        let filteredEntries = entries.filter { $0.sleepStages == sleepStage }
        let totalDuration = filteredEntries.reduce(0) { $0 + $1.duration }
        return totalDuration
    }
}

struct Series: Identifiable {
    /// Data Group.
    let category: String

    /// Size of data in gigabytes?
    let size: Double

    /// The identifier for the series.
    var id: String { category }
}

enum Constants {
    static let previewChartHeight: CGFloat = 100
    static let detailChartHeight: CGFloat = 300
}


