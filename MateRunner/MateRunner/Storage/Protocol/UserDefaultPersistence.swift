//
//  UserDefaultPersistence.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/17.
//

import Foundation

protocol UserDefaultPersistence {
    func setValue(_ value: Any?, key: UserDefaultKey)
    func getStringValue(key: UserDefaultKey) -> String?
    func getBooleanValue(key: UserDefaultKey) -> Bool
}
