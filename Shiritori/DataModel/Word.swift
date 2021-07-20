//
//  WordModel.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/07/20.
//

import Foundation
import RealmSwift

class Word: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var isLike: Bool = false
}
