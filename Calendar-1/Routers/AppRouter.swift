//
//  AppRouter.swift
//  Calendar-1
//
//  Created by Şahin Karahan on 9.01.2025.
//

import Foundation


enum AppRouter: Hashable {
    case day(date: Date)
    case booking(date: Date)
    case confirmation(date: Date)
}
