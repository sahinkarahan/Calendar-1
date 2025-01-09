//
//  DayView.swift
//  Calendar-1
//
//  Created by Şahin Karahan on 8.01.2025.
//

import SwiftUI

struct DayView: View {
    @EnvironmentObject var manager: DatabaseManager
    
    @State var dates = [Date]()
    @State var selectedDate: Date?
    @Binding var path: NavigationPath
    var currentDate: Date
    
    var body: some View {
        ScrollView {
            VStack {
                Text(currentDate.fullMonthDayYearFormat())
                    
                Divider()
                    .padding(.vertical)
                
                Text("Select a Time")
                    .font(.largeTitle)
                    .bold()
                
                Text("Duration: 30 mins")
                
                ForEach(dates, id: \.self) { date in
                    HStack {
                        Button {
                            withAnimation {
                                selectedDate = date
                            }
                        } label: {
                            Text(date.timeFromDate())
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(selectedDate == date ? .white :.blue)
                                .background(
                                    ZStack {
                                        Group {
                                            if selectedDate == date {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundStyle(.gray)
                                            } else {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke()
                                            }
                                        }
                                    }
                                )
                        }
                        if selectedDate == date {
                            NavigationLink(value: AppRouter.booking(date: date)) {
                                Text("Next")
                                    .bold()
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.blue)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            self.dates = manager.avaliableDates.filter({ $0.monthDayYearFormat() == currentDate.monthDayYearFormat() })
        }
        .navigationTitle(currentDate.dayOfTheWeek())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DayView(path: .constant(NavigationPath()), currentDate: Date())
    }
}
