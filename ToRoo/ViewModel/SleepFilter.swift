import Foundation

struct SleepFilter {
    private let calendar = Calendar.current
    
    //MARK: PROBLEM HAPPEN
    static func startOfOpeningHours(selectedDate: Date) -> Date{
        let dayChart = selectedDate.toString(format: "dd")
        let monthChart = selectedDate.toString(format: "MM")
        let yearChart = selectedDate.toString(format: "yyyy")
        let startTime = date(year: Int(yearChart)!, month: Int(monthChart)!, day: Int(dayChart)!-1, hour: 19, minutes: 00)

        return startTime
    }

    static func endOfOpeningHours(selectedDate: Date) -> Date {
        let dayChart = selectedDate.toString(format: "dd")
        let monthChart = selectedDate.toString(format: "MM")
        let yearChart = selectedDate.toString(format: "yyyy")
        let endTime = date(year: Int(yearChart)!, month: Int(monthChart)!, day: Int(dayChart)!, hour: 9, minutes: 59)

        return endTime
    }
    
    func filteringSleepStages(sleepData: [SleepEntry],selectedDay: Date, sleepStage: String, startOfOpeningHours: Date, endOfOpeningHours: Date) -> [SleepEntry] {
        let filteredEntries = sleepData.filter { entry in
            entry.startDate >= startOfOpeningHours && entry.endDate <= endOfOpeningHours && entry.sleepStages == sleepStage
        }
        
        return filteredEntries
        
    }
    
    func calculateDuration(sleepData: [SleepEntry], selectedDay: Date, sleepStage: String,startOfOpeningHours: Date, endOfOpeningHours: Date) -> Double {
        
        let filteredEntries = filteringSleepStages(sleepData: sleepData, selectedDay: selectedDay, sleepStage: sleepStage, startOfOpeningHours: startOfOpeningHours, endOfOpeningHours: endOfOpeningHours)
        
        
        
        let totalDuration = filteredEntries.reduce(0) { $0 + $1.duration }
        
        return totalDuration
    }
    
    static func calculateInBed(sleepData: [SleepEntry],selectedDay: Date) -> Double {
        let filteredEntriesInBed = sleepData.filter { entry in
            entry.startDate >= SleepFilter.startOfOpeningHours(selectedDate: selectedDay) && entry.endDate <= SleepFilter.endOfOpeningHours(selectedDate: selectedDay) && entry.sleepStages == "In Bed"
        }
        let totalInBedDuration = filteredEntriesInBed.reduce(0) { $0 + $1.duration }
        
        return totalInBedDuration
    }
    
    static func calculateTotal(sleepData: [SleepEntry],selectedDay: Date) -> Double{
        let filteredEntries = sleepData.filter { entry in
            entry.startDate >= SleepFilter.startOfOpeningHours(selectedDate: selectedDay) && entry.endDate <= SleepFilter.endOfOpeningHours(selectedDate: selectedDay) && entry.sleepStages != "Unspecified" && entry.sleepStages != "In Bed"
        }
        let totalDuration = filteredEntries.reduce(0) { $0 + $1.duration }
        
        return totalDuration
    }

}


