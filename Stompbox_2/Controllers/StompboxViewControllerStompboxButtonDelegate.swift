//
//  StompboxViewControllerStompboxButtonDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/19/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import AVFoundation

extension StompboxViewController: StompboxButtonDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func stompboxButtonTapped(_ button: StompboxButton) {
    print("delegate message received")
    showPhotoMenu()
  }
  
  func showPhotoMenu() {
    print("showPhotoMenu()")
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
      self.takePhotoWithCamera()
    })
    let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
      self.choosePhotoFromLibrary()
    })
    
    alert.addAction(actCancel)
    alert.addAction(actPhoto)
    alert.addAction(actLibrary)
    
    present(alert, animated: true, completion: nil)
  }
  
  func takePhotoWithCamera() {
    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    
    func takePhoto() {
      imagePicker.sourceType = .camera
      imagePicker.delegate = self
      present(imagePicker, animated: true, completion: nil)
    }
    
    switch authStatus {
    case .authorized:
      takePhoto()
    case .denied:
      alertPromptToAllowCameraAccessViaSetting()
    default:
      takePhoto()
    }
  }
  
  func choosePhotoFromLibrary() {
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    present(imagePicker, animated: true, completion: nil)
  }
  
  private func updateThumbnail() {
    if didPickNewThumbnail {
      let filePath = createUniqueJPGFilePath()
      do {
        try? imageData.write(to: filePath, options: .atomic)
        selectedStompbox?.imageFilePath = filePath.absoluteURL
      }
    }
  }
  
  func alertPromptToAllowCameraAccessViaSetting() {
    let alert = UIAlertController(title: "Allow Stompbox to access your camera to use this feature",
                                  message: nil,
                                  preferredStyle: .alert)
    
    let settingsAction = UIAlertAction(title: "Settings", style: .cancel) { (alert) -> Void in
      if let url = URL(string:UIApplicationOpenSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default)
    alert.addAction(settingsAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: - Image Picker Delegates
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    didPickNewThumbnail = true
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
   // let thumbnailPNG = image.resized(withBounds: self.stompboxButton.bounds.size)
    //self.imageData = UIImageJPEGRepresentation(thumbnailPNG, 0.4)!
    DispatchQueue.main.async {
     // self.stompboxButton.setImage(UIImage(data: self.imageData), for: UIControlState.normal)
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
