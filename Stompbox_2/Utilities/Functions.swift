//
//  Functions.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

let CoreDataSaveFailedNotification = Notification.Name(rawValue: "CoreDataSaveFailedNotification")

let blue = UIColor(red: 4/255, green: 169/255, blue: 255/255, alpha: 1.0)
let black = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
let lightGray = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)
let settingCellLight = UIColor(red: 25/255, green: 25/255, blue: 30/255, alpha: 1.0)
let settingCellDark = UIColor(red: 20/255, green: 20/255, blue: 25/255, alpha: 1.0)

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
