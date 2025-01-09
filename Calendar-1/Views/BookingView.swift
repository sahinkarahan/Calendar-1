//
//  BookingView.swift
//  Calendar-1
//
//  Created by Şahin Karahan on 8.01.2025.
//

import SwiftUI

struct BookingView: View {
    @EnvironmentObject var manager: DatabaseManager
    
    @State private var name = ""
    @State private var email = ""
    @State private var notes = ""
    
    @Binding var path: NavigationPath
    
    var currentDate: Date
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "clock")
                    
                    Text("30 min")
                }
                
                HStack {
                    Image(systemName: "video")
                    
                    Text("FaceTime")
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "calendar")
                    
                    Text(currentDate.bookingViewDateFormat())
                }
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Enter Details")
                    .font(.title)
                    .bold()
                
                Text("Name")
                TextField("", text: $name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                
                Text("Email")
                TextField("", text: $email)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                
                Text("Please share anything that will help prepare for our meeting.")
                TextField("", text: $notes, axis: .vertical)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                
                Spacer()
                
                Button {
                    if !name.isEmpty && !email.isEmpty {
                        Task {
                            do {
                                try await manager.bookAppointment(name: name, email: email, notes: notes, date: currentDate)
                                name = ""
                                email = ""
                                notes = ""
                                path.append(AppRouter.confirmation(date: currentDate))
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                } label: {
                    Text("Schedule Event")
                        .padding()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.blue)
                        )
                }
                
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("Calendly Meeting Plan")
    }
}

#Preview {
    NavigationStack {
        BookingView(path: .constant(NavigationPath()), currentDate: Date())
    }
}
