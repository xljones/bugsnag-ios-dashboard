//
//  Helpers.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 19/12/2021.
//

import Foundation
import Bugsnag

// MARK: - Mathematical helpers
/// Function to convert an integer to a compressed 1,000 (k) or 1,000,000 (M) value
/// and round it to one decimal place.
public func applyCondensedUnits(value: Int) -> String {
    let valAsDouble = Double(value)
    if value >= 1000000 {
        let valRounded = ((valAsDouble / Double(1000000)) * 10).rounded() / 10.0
        return "\(valRounded)M"
    } else if value >= 1000 {
        let valRounded = ((valAsDouble / Double(1000)) * 10).rounded() / 10.0
        return "\(valRounded)k"
    } else {
        return String(value)
    }
}

// MARK: - Date / Time helpers

/// Given an ISO8601 Timestamp, it converts this to a user friendly string relative to the current time/date
// TODO: - Update this to work relative to the users timezone. Does the ISO8601Formatter() already take care of this?
public func getRelativeTimestamp(iso8601Timestamp: String) -> String {
    // https://stackoverflow.com/a/42101630/6277366 setup formatter for Rails formatted output
    let railsIso8601Formatter = ISO8601DateFormatter()
    railsIso8601Formatter.formatOptions = [.withFullDate,
                                           .withTime,
                                           .withDashSeparatorInDate,
                                           .withColonSeparatorInTime]
    let timestamp = railsIso8601Formatter.date(from: iso8601Timestamp)
    if timestamp != nil {
        return RelativeDateTimeFormatter().localizedString(for: timestamp!, relativeTo: Date())
    } else {
        return iso8601Timestamp
    }
}

public func friendlyDatefromTimestamp(iso8601Timestamp: String) -> String {
    let railsIso8601Formatter = ISO8601DateFormatter()
    railsIso8601Formatter.formatOptions = [.withFullDate,
                                           .withTime,
                                           .withDashSeparatorInDate,
                                           .withColonSeparatorInTime]
    let timestamp = railsIso8601Formatter.date(from: iso8601Timestamp)
    if timestamp != nil {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: timestamp!)
    } else {
        return iso8601Timestamp
    }
}


/// Given two ISO 8601 Timestamp strings, calculated a friendly first and last seen timestamp
/// such as "about 1 month ago", "about 1 hour ago", or "about 1 month ago – 5 months ago"
public func friendlyFirstLastSeenTimestamp(firstSeenIso8601Timestamp: String, lastSeenIso8601Timestamp: String) -> String {
    let firstSeenRelative = getRelativeTimestamp(iso8601Timestamp: firstSeenIso8601Timestamp)
    let lastSeenRelative = getRelativeTimestamp(iso8601Timestamp: lastSeenIso8601Timestamp)
    
    if firstSeenRelative == lastSeenRelative {
        return "about " + lastSeenRelative
    } else {
        return "about " + lastSeenRelative + " – " + firstSeenRelative
    }
}

/// Caculates stability as a % to 1 decimal place given a user or session unhandled rate.
public func calcStabilityPercentage(unhandledRate: Double) -> Double {
    return ((1 - unhandledRate) * 1000).rounded() / 10
}

// MARK: - Logging
public func logMessage(message: Any, addAsBugsnagBreadcrumb: Bool = false) {
    #if DEBUG
    print(message)
    #endif
    if addAsBugsnagBreadcrumb, let messageAsString = message as? String {
        Bugsnag.leaveBreadcrumb(withMessage: messageAsString)
    }
}
