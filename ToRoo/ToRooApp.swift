//
//  ToRooApp.swift
//  ToRoo
//
//  Created by Safik Widiantoro on 30/05/23.
//

import SwiftUI

@main
struct ToRooApp: App {
//    let persistenceController = PersistenceController.shared
    @AppStorage("isFirstOpenApp") var isFirstOpenApp: Bool = true
    @StateObject var healthStore = SleepStore()
    @StateObject var weekStore: WeekStore = WeekStore()
    
    func onCompleteOnBoarding() {
        isFirstOpenApp = false
    }

    var body: some Scene {
        WindowGroup {
                ContentView()
                .environmentObject(healthStore)
                .environmentObject(weekStore)
                .preferredColorScheme(.light)
            }
//        }
    }
}
