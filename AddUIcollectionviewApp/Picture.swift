//
//  File.swift
//  AddUIcollectionviewApp
//
//  Created by mac on 2018/10/27.
//  Copyright © 2018年 mac. All rights reserved.
//

import Foundation
struct Picture : Codable{
   
    var image : Data
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory,  in: .userDomainMask).first!
    
    //需要Codable才能轉型
    static func saveFile(picture: [Picture]){
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(picture){
            let url = Picture.documentsDirectory.appendingPathComponent("picture")
            try? data.write(to: url)
            print(url)
        }
    }
    static func readFromFile() -> [Picture]? {
        let  propertyDecoder = PropertyListDecoder()
        let url = Picture.documentsDirectory.appendingPathComponent("picture")
        print(url)
        if let data = try? Data(contentsOf: url),let lovers = try? propertyDecoder.decode([Picture].self, from: data){
            return lovers
        }else{
            return nil
        }
    }
}
