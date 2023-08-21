//
//  SleepStore.swift
//  beSafik
//
//  Created by Safik Widiantoro on 27/05/23.
//

import HealthKit



class SleepStore: ObservableObject {
    @Published var healthStore: HKHealthStore?
    @Published var sleepData: [SleepEntry] = []
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }else{
            print("HealthKit Not Available")
        }
    }

    func requestAuthorization() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        healthStore?.requestAuthorization(toShare: nil, read: [sleepType]) { success, error in
            if error != nil {
                print("Error Authorizing \(String(describing: error))")
                return
            }
            else if success {
                // Both authorization granted or not still call success block
                // Refer: https://developer.apple.com/documentation/healthkit/hkauthorizationstatus
                print("Success Authorizing")
                self.fetchSleepAnalysisData(calculatePreviousDate(Date()), Date())
            }
        }
    }
    
    func fetchSleepAnalysisData(_ startDate: Date, _ endDate: Date) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            // Sleep analysis not available
            print("Sleep analysis not available")
            return
        }
        
        let startDate = startDate
        let endDate = endDate
        
        let predicate = NSPredicate(
            format: "startDate >= %@ AND endDate <= %@",
            startDate as NSDate,
            endDate as NSDate
        )

        let query = HKSampleQuery(
            sampleType: sleepType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { query, results, error in
            if error != nil {
                // Handle error
                return
            }
            
            if let sleepSamples = results as? [HKCategorySample] {
                self.processSleepSamples(sleepSamples)
            }
        }
        self.healthStore?.execute(query)
    }
    
    func processSleepSamples(_ samples: [HKCategorySample]) {
        var sleepData: [SleepEntry] = []
        
        for sample in samples {
            let startDate = sample.startDate
            let endDate = sample.endDate

            // Determine the sleep quality based on the value of the sample
            let sleepStages: String
            switch sample.value {
                case HKCategoryValueSleepAnalysis.inBed.rawValue:
                    sleepStages = "In Bed"
                case HKCategoryValueSleepAnalysis.awake.rawValue:
                    sleepStages = "Awake"
                case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                    sleepStages = "REM"
                case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                    sleepStages = "Deep"
                case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                    sleepStages = "Core"
                default:
                    sleepStages = "Unspecified"
            }
            
            // Calculate the duration of the sleep sample
            let duration = endDate.timeIntervalSince(startDate)

            // Create a SleepEntry object and add it to the sleepData array
            let sleepEntry = SleepEntry(id: UUID(), startDate: startDate, endDate: endDate, sleepStages: sleepStages, duration: duration)
            
            sleepData.append(sleepEntry)
            print(sleepEntry)
        }
        
        DispatchQueue.main.async {
            // Update your SwiftUI view with the processed sleep data on the main thread
            self.sleepData = sleepData
        }
    }
 
}



