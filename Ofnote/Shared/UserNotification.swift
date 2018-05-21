//
//  UserNotification.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/20/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import Foundation
import UserNotifications

struct UserNotification {

    static let shared = UserNotification()
    static let id = "noteNotification"

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { granted, error in
            if granted && error == nil {
                print("OK")
            } else {
                print(error!)
            }
        })
    }

    func scheduleNotification(with date: Date, note: Note, completion: @escaping (Bool) -> Void) {

        guard let imageURL = Bundle.main.url(forResource: "forget", withExtension: "png") else {
            print("NO IMAGE")
            completion(false)
            return
        }

        let notification = UNMutableNotificationContent()
        notification.title = note.title
        let attachment: UNNotificationAttachment
        do {
            attachment = try UNNotificationAttachment(identifier: UserNotification.id, url: imageURL, options: .none)
            notification.attachments = [attachment]
        } catch {
            print(error)
        }
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UserNotification.id, content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}


