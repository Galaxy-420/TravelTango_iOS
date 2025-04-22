//
//  RemindersViewModel.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import Foundation
import UserNotifications
import SwiftUI

class RemindersViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []

    func add(_ reminder: Reminder) {
        reminders.append(reminder)
        scheduleNotification(for: reminder)
    }

    func update(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
            removeNotification(id: reminder.id.uuidString)
            scheduleNotification(for: reminder)
        }
    }

    func delete(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
        removeNotification(id: reminder.id.uuidString)
    }

    private func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Payment Reminder"
        content.body = reminder.title + ": " + reminder.description
        content.sound = .default

        let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: reminder.date) ?? reminder.date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day], from: triggerDate), repeats: false)

        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    private func removeNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

