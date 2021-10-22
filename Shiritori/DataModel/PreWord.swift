//
//  WordModel.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/07/20.
//
import RealmSwift

class PreWord: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var isLike: Bool = false
}
