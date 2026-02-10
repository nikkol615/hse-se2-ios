//
//  CalendarManager.swift
//  ndkolobanovPW2
//
//  Created by Никита Колобанов on 02/10/26.
//

import EventKit

// MARK: - CalendarManaging Protocol
protocol CalendarManaging {
    func create(eventModel: WishEventModel) -> Bool
}

// MARK: - CalendarManager
final class CalendarManager: CalendarManaging {
    private let eventStore: EKEventStore = EKEventStore()

    func create(eventModel: WishEventModel) -> Bool {
        var result: Bool = false
        let group = DispatchGroup()
        group.enter()

        create(eventModel: eventModel) { isCreated in
            result = isCreated
            group.leave()
        }

        group.wait()
        return result
    }

    func create(eventModel: WishEventModel, completion: ((Bool) -> Void)?) {
        let createEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted, error) in
            guard granted, error == nil, let self else {
                completion?(false)
                return
            }

            let event = EKEvent(eventStore: self.eventStore)
            event.title = eventModel.title
            event.startDate = eventModel.startDate
            event.endDate = eventModel.endDate
            event.notes = eventModel.description
            event.calendar = self.eventStore.defaultCalendarForNewEvents

            do {
                try self.eventStore.save(event, span: .thisEvent)
                completion?(true)
            } catch {
                print("Failed to save event with error: \(error)")
                completion?(false)
            }
        }

        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: createEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: createEvent)
        }
    }
}
