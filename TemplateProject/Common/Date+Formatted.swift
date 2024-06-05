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
}
