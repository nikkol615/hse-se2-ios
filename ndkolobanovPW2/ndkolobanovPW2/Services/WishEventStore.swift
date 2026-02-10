//
//  WishEventStore.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 02/10/26.
//

import Foundation

// MARK: - WishEventStore
final class WishEventStore {
    private enum Constants {
        static let eventsKey: String = "savedWishEvents"
    }

    private let defaults = UserDefaults.standard

    var events: [WishEventModel] {
        get {
            guard let data = defaults.data(forKey: Constants.eventsKey),
                  let decoded = try? JSONDecoder().decode([WishEventModel].self, from: data) else {
                return []
            }
            return decoded
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                defaults.set(encoded, forKey: Constants.eventsKey)
            }
        }
    }

    func addEvent(_ event: WishEventModel) {
        var current = events
        current.append(event)
        events = current
    }

    func removeEvent(at index: Int) {
        var current = events
        guard index >= 0, index < current.count else { return }
        current.remove(at: index)
        events = current
    }
}
