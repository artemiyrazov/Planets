//
//	UserSettings.swift
// 	Planets
//

import Foundation

final class UserSettings {
    static var isDataFromFileLoaded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isDataFromFileLoaded")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isDataFromFileLoaded")
        }
    }
}
