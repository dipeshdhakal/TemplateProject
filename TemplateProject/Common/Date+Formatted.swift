//
//  Date+Formatted.swift
//  XeroProgrammingExercise
//
//  Created by Dipesh Dhakal on 17/10/2023.
//

import Foundation

extension Date {
    func string(formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    static var customFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    static var serverFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
}

extension String {
    var date: Date? {
        return DateFormatter.customFormatter.date(from: self)
    }
    var serverDate: Date? {
        return DateFormatter.serverFormatter.date(from: self)
    }
}
