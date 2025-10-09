//
//  SecondView.swift
//  hoW_Work
//
//  Created by 이지현 on 10/3/25.
//

import SwiftUI

struct Event: Identifiable {
    var id = UUID()
    var startTime: Date
    var endTime: Date
    var title: String
    
}

struct SecondView: View {
    @State private var startTime = Date()
    @State private var endTime: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var selectedDate = Date()
    @State private var eveTitle: String = ""
    @State private var events: [Event] = []
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Sel Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]//날짜,시간
                )
                .datePickerStyle(.graphical)
                
                DatePicker(
                    "Start Date",
                    selection: $startTime,
                    displayedComponents: [.hourAndMinute]//날짜,시간
                )
                .datePickerStyle(.compact)
                
                DatePicker(
                    "end Date",
                    selection: $endTime,
                    in: startTime...,displayedComponents: [.hourAndMinute]//날짜,시간
                )
                .datePickerStyle(.compact)
                
                TextField("Event Title", text: $eveTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                
                Button(action: {
                    let startTime = combine(date: selectedDate, time: startTime)
                    let endTime = combine(date: selectedDate, time: endTime)
                    let newEvent=Event( startTime: startTime, endTime: endTime, title: eveTitle)
                    events.append(newEvent)
                    eveTitle = ""
                }) {
                    Text("Add Event")
                    }
                
                Divider()
                
                List(events) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.headline)
                        Text(formattedDate(event.startTime))
                            .font(.subheadline)
                        Text(formattedDate(event.endTime))
                    }
                    
                }
            }
        }
    }
    
    func combine(date: Date, time: Date) -> Date {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

            var combined = DateComponents()
            combined.year = dateComponents.year
            combined.month = dateComponents.month
            combined.day = dateComponents.day
            combined.hour = timeComponents.hour
            combined.minute = timeComponents.minute

            return calendar.date(from: combined) ?? date
        }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    
}
