import UIKit
import Flutter
import EventKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController

        // Set up the platform channel
        let calendarChannel = FlutterMethodChannel(name: "com.pickle.app/calendar",
                                                  binaryMessenger: controller.binaryMessenger)
        calendarChannel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            if call.method == "fetchAppleCalendarEvents" {
                self.fetchAppleCalendarEvents(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func fetchAppleCalendarEvents(result: @escaping FlutterResult) {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            let calendars = eventStore.calendars(for: .event)
            let events = self.fetchEvents(from: calendars, in: eventStore)
            result(events)
        case .notDetermined:
            eventStore.requestAccess(to: .event) { [weak self] (granted, error) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if granted {
                        let calendars = eventStore.calendars(for: .event)
                        let events = self.fetchEvents(from: calendars, in: eventStore)
                        result(events)
                    } else {
                        result(FlutterError(code: "PERMISSION_DENIED",
                                           message: "Calendar access denied",
                                           details: nil))
                    }
                }
            }
        default:
            result(FlutterError(code: "PERMISSION_DENIED",
                               message: "Calendar access denied",
                               details: nil))
        }
    }

    private func fetchEvents(from calendars: [EKCalendar], in eventStore: EKEventStore) -> [[String: Any]] {
        let startDate = Date() // Today
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)! // Next 1 year
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = eventStore.events(matching: predicate)
        return events.map { event in
            return [
                "title": event.title ?? "No Title",
                "startDate": event.startDate.timeIntervalSince1970,
                "endDate": event.endDate.timeIntervalSince1970,
            ]
        }
    }
}
