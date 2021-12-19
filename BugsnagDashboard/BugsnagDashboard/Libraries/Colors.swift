//
//  Colors.swift
//  BugsnagDashboard
//
//  Created by Xander Jones on 29/07/2021.
//

import Foundation
import SwiftUI

/// SwiftUI `Color` is incomplete by comparison to `UIColor`, so extend to fix this
extension Color {
     
    // MARK: - Text Colors
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)
    static let placeholderText = Color(UIColor.placeholderText)

    // MARK: - Label Colors
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    // MARK: - Background Colors
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    // MARK: - Fill Colors
    static let systemFill = Color(UIColor.systemFill)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
    
    // MARK: - Grouped Background Colors
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    
    // MARK: - Gray Colors
    static let systemGray = Color(UIColor.systemGray)
    static let systemGray2 = Color(UIColor.systemGray2)
    static let systemGray3 = Color(UIColor.systemGray3)
    static let systemGray4 = Color(UIColor.systemGray4)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGray6 = Color(UIColor.systemGray6)
    
    // MARK: - Other Colors
    static let separator = Color(UIColor.separator)
    static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    static let link = Color(UIColor.link)
    
    // MARK: System Colors
    static let systemBlue = Color(UIColor.systemBlue)
    static let systemPurple = Color(UIColor.systemPurple)
    static let systemGreen = Color(UIColor.systemGreen)
    static let systemYellow = Color(UIColor.systemYellow)
    static let systemOrange = Color(UIColor.systemOrange)
    static let systemPink = Color(UIColor.systemPink)
    static let systemRed = Color(UIColor.systemRed)
    static let systemTeal = Color(UIColor.systemTeal)
    static let systemIndigo = Color(UIColor.systemIndigo)

}

// Bugsnag Primary color scheme
public struct BSGPrimaryColors {
    public static let indigo = Color(red: 73/255, green: 73/255, blue: 228/255)
    public static let midnight = Color(red: 0/255, green: 13/255, blue: 71/255)
}

// Bugsnag Secondary color scheme
public struct BSGSecondaryColors {
    public static let pacific = Color(red: 55/255, green: 194/255, blue: 217/255)
    public static let sunflower = Color(red: 255/255, green: 163/255, blue: 0/255)
    public static let orchid = Color(red: 161/255, green: 95/255, blue: 255/255)
    public static let coral = Color(red: 255/255, green: 90/255, blue: 96/255)
    public static let green = Color(red: 140/255, green: 198/255, blue: 63/255)
}
