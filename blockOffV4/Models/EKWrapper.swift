//
//  EKWrapper.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import UIKit
import CalendarKit
import EventKit


// THIS NEEDS TO ACCEPT BOTH ekEvents and cdEvents
// Try following the AnalyticsProduct convienance init pattern

public final class EKWrapper: EventDescriptor, Identifiable, Hashable, Equatable {
    
    public static func == (lhs: EKWrapper, rhs: EKWrapper) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var dateInterval: DateInterval {
        get {
            return DateInterval(start: ekEvent.startDate, end: ekEvent.endDate)
        }
        set {
            ekEvent.startDate = newValue.start
            ekEvent.endDate = newValue.end
        }
    }
    
    public var id: String {
        return ekEvent.eventIdentifier
    }
    
    public var isAllDay: Bool {
        get {
            return ekEvent.isAllDay
        }
        set {
            ekEvent.isAllDay = newValue
        }
    }
    
    public var text: String {
        get {
            return ekEvent.title
        }
        set {
            ekEvent.title = newValue
        }
    }
    
    public var attributedText: NSAttributedString?
    public var lineBreakMode: NSLineBreakMode?
    
    public var color: UIColor {
        get {
            return .lightGray
           // UIColor(cgColor: ekEvent.calendar.cgColor)
        }
    }
    
    public var backgroundColor = SystemColors.systemBlue.withAlphaComponent(0.3)
    public var textColor = SystemColors.label
    
    public var font = UIFont.boldSystemFont(ofSize: 12)
    public var userInfo: Any?
    public weak var editedEvent: EventDescriptor? {
        didSet {
            updateColors()
        }
    }
    
    public private(set) var ekEvent: EKEvent
    public init(eventKitEvent: EKEvent) {
        self.ekEvent = eventKitEvent
        self.updateColors()
    }
    
    public func makeEditable() -> EKWrapper {
        let cloned = Self(eventKitEvent: ekEvent)
        cloned.editedEvent = self
        return cloned
    }
    
    public func commitEditing() {
        guard let edited = editedEvent else {return}
        edited.dateInterval = dateInterval
    }
    
    private func updateColors() {
        (editedEvent != nil) ? applyEditingColors() : applyStandardColors()
    }
    
    /// Colors used when event is not in editing mode
    private func applyStandardColors() {
        backgroundColor = dynamicStandardBackgroundColor()
        textColor = dynamicStandardTextColor()
    }
    
    /// Colors used in editing mode
    private func applyEditingColors() {
        backgroundColor = color.withAlphaComponent(0.95)
        textColor = .white
    }
    
    /// Dynamic color that changes depending on the user interface style (dark / light)
    private func dynamicStandardBackgroundColor() -> UIColor {
        let light = backgroundColorForLightTheme(baseColor: color)
        let dark = backgroundColorForDarkTheme(baseColor: color)
        return dynamicColor(light: light, dark: dark)
    }
    
    /// Dynamic color that changes depending on the user interface style (dark / light)
    private func dynamicStandardTextColor() -> UIColor {
        let light = textColorForLightTheme(baseColor: color)
        return dynamicColor(light: light, dark: color)
    }
    
    private func textColorForLightTheme(baseColor: UIColor) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * 0.4, alpha: a)
    }
    
    private func backgroundColorForLightTheme(baseColor: UIColor) -> UIColor {
        baseColor.withAlphaComponent(0.3)
    }
    
    private func backgroundColorForDarkTheme(baseColor: UIColor) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * 0.4, alpha: a * 0.8)
    }
    
    private func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                let interfaceStyle = traitCollection.userInterfaceStyle
                switch interfaceStyle {
                case .dark:
                    return dark
                default:
                    return light
                }
            }
        } else {
            return light
        }
    }
}

