//
//  DatabaseManager.swift
//  Calendar-1
//
//  Created by Şahin Karahan on 8.01.2025.
//

import Foundation
import Supabase

struct Hours: Codable {
    let id: Int
    let createdAt: Date
    let day: Int
    let start: Int
    let end: Int
    
    enum CodingKeys: String, CodingKey {
        case id, day, start, end
        case createdAt = "created_at"
    }
    
}

struct Appointment: Codable {
    var id: Int?
    let createdAt: Date
    let name: String
    let email: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, date
        case createdAt = "created_at"
    }
}

class DatabaseManager: ObservableObject {
    
    @Published var avaliableDates = [Date]()
    @Published var days: Set<String> = []
    
    private let client = SupabaseClient(supabaseURL: URL(string: "https://ozkzmqcwpwwaewftfbkp.supabase.co")!   , supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96a3ptcWN3cHd3YWV3ZnRmYmtwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYzNTg0NzgsImV4cCI6MjA1MTkzNDQ3OH0.3VEtKzIV2yNl5EMe3wQSdFiA8oDs0tTAuzzM6Sd0prk")
    
      init() {
          Task {
              do {
                  let dates = try await self.fetchAvaliableAppointments()
                  await MainActor.run {
                      avaliableDates = dates
                      days = Set(avaliableDates.map({ $0.monthDayYearFormat() }))
                  }
              } catch {
                  print(error.localizedDescription)
              }
          }
    }
    
    private func fetchHours() async throws -> [Hours] {
            // Veritabanından veri çekme işlemi
        let response: [Hours] = try await client.from("hours").select().execute().value
        return response
        }
    
    private func fetchAvaliableAppointments() async throws -> [Date]  {
        let appts: [Appointment] = try await client.from("appointments").select().execute().value
        return try await generateAppointmentTimes(from: appts)
    }
    
    private func generateAppointmentTimes(from appts: [Appointment]) async throws -> [Date] {
        let takenAppts: Set<Date> = Set(appts.map({ $0.date }))
        let hours = try await fetchHours()
        let calendar = Calendar.current
        let currentWeekday = calendar.component(.weekday, from: Date()) - 2
        
        var timeSlots = [Date]()
        
        for weekOffSet in 0...2 {
            
            let daysOffset = weekOffSet * 7
           
            for hour in hours {
                if hour.start != 0 && hour.end != 0 {
                    var currentDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: calendar.component(.month, from: Date()),day: calendar.component(.day, from: Date()) + daysOffset + (hour.day - currentWeekday), hour: hour.start))!

                    while let nextDate = calendar.date(byAdding: .minute, value: 30, to: currentDate),
                        calendar.component(.hour, from: nextDate) <= hour.end {
                        if !takenAppts.contains(currentDate) && currentDate > Date() && calendar.component(.hour, from: currentDate) != hour.end {
                                timeSlots.append(currentDate)
                            }
                            currentDate = nextDate
                        }
                    }
            }
        }
        return timeSlots
    }
    
    func bookAppointment(name: String, email: String, notes: String, date: Date) async throws {
        let appointment = Appointment(createdAt: Date(), name: name, email: email, date: date)
        let _ = try await client.from("appointments").insert(appointment).execute()
    }
}
 
