//
//  WishEventModel.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 02/10/26.
//

import Foundation

struct WishEventModel: Codable {
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date

    var startDateString: String {
        return WishEventModel.dateFormatter.string(from: startDate)
    }

    var endDateString: String {
        return WishEventModel.dateFormatter.string(from: endDate)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
