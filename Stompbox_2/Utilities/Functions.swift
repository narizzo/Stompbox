//
//  Functions.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

let CoreDataSaveFailedNotification = Notification.Name(rawValue: "CoreDataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
  print("*** Fatal error: \(error)")
  NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}

func getDocumentsDirectory() -> URL {
  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  return paths[0]
}

func createUniqueJPGFilePath() -> URL {
  let uuid = NSUUID().uuidString
  return getDocumentsDirectory().appendingPathComponent(uuid + ".jpg")
}


extension UIImage {
  func resized(withBounds bounds: CGSize) -> UIImage {
    let horizontalRatio = bounds.width / size.width
    let verticalRatio = bounds.height / size.height
    let ratio = min(horizontalRatio, verticalRatio)
    let newSize = CGSize(width: size.width * ratio,
                         height: size.height * ratio)
    
    UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
    draw(in: CGRect(origin: CGPoint.zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
}

extension CALayer {
  func setAnchorPointY(to point: CGPoint) {
    anchorPoint.y = point.y / bounds.height
  }
}

/*
 func getPopertyListURL() -> URL {
 return getDocumentsDirectory().appendingPathComponent("dictionary.plist")
 }
 
 func savePropertyList(_ plist: Any) throws {
 let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
 try plistData.write(to: getPopertyListURL())
 }
 
 func loadPropertyList() throws -> [String:Int] {
 let plistURL = getPopertyListURL()
 let data = try Data(contentsOf: plistURL)
 guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String:Int] else {
 return [String:Int]()
 }
 return plist
 }
 
 func createDefaultDictionary() throws {
 do {
 let dictionary: [String:Int] = ["Triangle":3, "Upside Down Triangle":3]
 try savePropertyList(dictionary)
 } catch {
 print(error)
 }
 }
 
 func addDictionaryEntry(key: String, value: Int) throws {
 do {
 var dictionary = try loadPropertyList()
 dictionary.updateValue(value, forKey: key)
 try savePropertyList(dictionary)
 } catch {
 print(error)
 }
 }
 
 */
