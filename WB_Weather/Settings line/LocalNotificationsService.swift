//
//  LocalNotificationsService.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 26.05.2023.
//

import Foundation
import UserNotifications
import UIKit

protocol LocalNotificationsServiceProtocol {
    func registerNotification()
    func deleteNotification()
}


final class LocalNotificationsService:  NSObject {

    /// Регистрируем категорию и задаём ей действия
    /// - Parameter center: центр оповещений
    private func registerCategory(for center: UNUserNotificationCenter) {
        let action1 = UNNotificationAction(
            identifier: "Close",
            title: "LocalNotificationsService.notification.action1".localized,
            options: [.destructive]
        )
        let action2 = UNNotificationAction(
            identifier: "Delay",
            title: "LocalNotificationsService.notification.action2".localized,
            options: [.authenticationRequired],
            icon: UNNotificationActionIcon(systemImageName: "clock.arrow.circlepath")
        )
        let categoryForecast = UNNotificationCategory(identifier: "categoryForecast", actions: [action1, action2], intentIdentifiers: [])
        let category: Set<UNNotificationCategory> = [categoryForecast]

        center.setNotificationCategories(category)
    }

    private func dismisBadge() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber -= 1
        }
    }
}

extension LocalNotificationsService: LocalNotificationsServiceProtocol {
    func registerNotification() {
        let center = UNUserNotificationCenter.current()
        self.registerCategory(for: center)
        center.delegate = self

        center.requestAuthorization(options: [.provisional, .alert, .sound, .badge]) { success, error in
            if success {
                var currentBadge = 0
                DispatchQueue.main.sync {
                    currentBadge = UIApplication.shared.applicationIconBadgeNumber
                }
                let content = UNMutableNotificationContent()
                content.title = "LocalNotificationsService.notification.title".localized
                content.body = "LocalNotificationsService.notification.body".localized
                content.badge = (currentBadge + 1) as NSNumber
                content.categoryIdentifier = "categoryForecast"

                var components = DateComponents()
                components.hour = 7
                components.minute = 0
                let triger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

                let request = UNNotificationRequest(identifier: "Morning forecast", content: content, trigger: triger)

                center.add(request)
            } else {
                print("⛔️", error ?? "Unknown error")
            }
        }
    }

    func deleteNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["Morning forecast"])
    }
}

extension LocalNotificationsService: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "Close":
            self.dismisBadge()
        case "Delay":
            self.dismisBadge()
            let center = UNUserNotificationCenter.current()
            let triger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
            let request = UNNotificationRequest(identifier: "Morning forecast", content: response.notification.request.content, trigger: triger)

            center.add(request)
        default:
            print("🤷🏻‍♂️ press unknow button")
        }
        completionHandler()
    }
}
