//
//  ConfirmationView.swift
//  Calendar-1
//
//  Created by Şahin Karahan on 8.01.2025.
//

import SwiftUI

struct ConfirmationView: View {
    
    @Binding var path: NavigationPath
    var currentDate: Date
    
    
    var body: some View {
        VStack {
            Image("sahin")
                .resizable()
                .scaledToFill()
                .frame(width: 128, height: 128)
                .clipShape(.rect(cornerRadius: 64))
            
            Text("Confirmed")
                .font(.title)
                .bold()
                .padding()
            
            Text("You are scheduled with Şahin Karahan.")
            
            Divider()
                .padding()
            
            VStack(alignment: .leading, spacing: 32) {
                HStack {
                    Circle()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.blue)
                    
                    Text("Calendly Meeting Plan")
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
            Spacer()
            
            Button {
                path = NavigationPath()
            } label: {
                Text("Done")
                    .bold()
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
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavigationStack {
        ConfirmationView(path: .constant(NavigationPath()) ,currentDate: Date())
    }
}
