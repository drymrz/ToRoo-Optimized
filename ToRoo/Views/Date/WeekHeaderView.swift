//
//  WeekHeaderView.swift
//  ToRoo
//
//  Created by Safik Widiantoro on 06/06/23.
//

import SwiftUI

struct WeekHeaderView: View {
    @EnvironmentObject var weekStore: WeekStore
    
    var body: some View {
        VStack{
            HStack {
                Text(weekStore.selectedDate.monthToString())
                    .font(.sfRoundedHeavy(fontSize: 32))
                Text(weekStore.selectedDate.toString(format: "yyyy"))
                    .font(.sfRoundedSemiBold(fontSize: 32))
            }
            Button{
                withAnimation {
                    weekStore.selectToday()
                }
            } label: {
                Text("Today")
                    .font(.sfRoundedSemiBold(fontSize: 14))
                    .foregroundColor(.primary)
                    .padding(4)
                    .background(.secondary)
                    .cornerRadius(4)
            }
            
            
            
        }.padding(.bottom, -15)
        
    }
}
