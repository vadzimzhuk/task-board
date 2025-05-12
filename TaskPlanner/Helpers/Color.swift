//
//  Color.swift
//  TaskPlanner
//

import Foundation
import SwiftUI

extension Color {
    static let theme = Theme()
}

struct Theme {
    let background = Color("Background")
    let ocean = Color("Ocean")
    let secondaryText = Color("SecondaryText")
    let secondaryAccent = Color("SecondaryAccent")
    let darkBackground = Color("DarkBackground")
}

extension Color {
    func encode() throws -> Data {
        let platformColor = UIColor(self)
        return try NSKeyedArchiver.archivedData(withRootObject: platformColor,
                                                requiringSecureCoding: true)
    }

    static func decodeColor(from data: Data) throws -> Color {
        guard let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self,from: data) else {
            throw NSError(domain: "", code: 0)
        }
        
        return Color(uiColor: uiColor)
    }
}
