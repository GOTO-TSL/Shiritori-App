//
//  UserDefaults.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/26.
//

import Foundation

extension UserDefaults {

    func setEnum<T: RawRepresentable>(_ value: T?, forKey key: String) where T.RawValue == String {
        if let value = value {
            set(value.rawValue, forKey: key)
        } else {
            removeObject(forKey: key)
        }
    }

    func getEnum<T: RawRepresentable>(forKey key: String) -> T? where T.RawValue == String {
        if let string = string(forKey: key) {
            return T(rawValue: string)
        }
        return nil
    }
}
