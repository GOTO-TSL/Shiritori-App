//
//  DictDataModel.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/19.
//

import SQLite3
import Foundation

struct DictDataModel {
    
    var database: OpaquePointer?
    
    mutating func openDB() {
        
        copyDataBaseFile()
        
        let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(Const.DBPath.fileName)
        guard let safefileURL = fileURL else { fatalError() }
        if sqlite3_open(safefileURL.path, &database) != SQLITE_OK {
            print("DBファイルが見つからず、生成もできません。")
        } else {
            print("DBファイルが生成できました。（対象のパスにDBファイルが存在しました。）")
        }
    }
    // DBファイルを実行ディレクトリにコピー
    private func copyDataBaseFile() {
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let finalDatabaseURL = documentsUrl.appendingPathComponent(Constant.DataBase.name)
        do {
            if !fileManager.fileExists(atPath: finalDatabaseURL.path) {
                //print("DB does not exist in documents folder")
                if let dbFilePath = Bundle.main.path(forResource: Constant.DataBase.fore, ofType: Constant.DataBase.back) {
                    try fileManager.copyItem(atPath: dbFilePath, toPath: finalDatabaseURL.path)
                } else {
                    //print("Uh oh - foo.db is not in the app bundle")
                }
            } else {
                //print("Database file found at path: \(finalDatabaseURL.path)")
            }
        } catch {
            //print("Unable to copy foo.db: \(error)")
        }
    }
}
