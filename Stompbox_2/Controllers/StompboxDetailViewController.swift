//
//  StompboxDetailViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/17/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

protocol StompboxDetailViewControllerDelegate: class {
  func stompboxDetailViewControllerDidCancel(_ controller: StompboxDetailViewController)
  func stompboxDetailViewController(_ controller: StompboxDetailViewController, didFinishAdding stompbox: Stompbox)
  func stompboxDetailViewController(_ controller: StompboxDetailViewController, didFinishEditing stompbox: Stompbox)
}

class StompboxDetailViewController: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var stompboxName: UITextField!
  @IBOutlet weak var stompboxType: UITextField!
  @IBOutlet weak var stompboxManufacturer: UITextField!
  @IBOutlet weak var stompboxButton: UIButton!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  weak var delegate: StompboxDetailViewControllerDelegate?
  var coreDataStack: CoreDataStack!
  var stompboxToEdit: Stompbox?
  
  let imagePicker = UIImagePickerController()
  var imageData = Data()
  var didPickNewThumbnail = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    doneButton.isEnabled = true
    stompboxButton.imageView?.contentMode = .scaleAspectFit
    navigationItem.largeTitleDisplayMode = .never
    title = "Add Stompbox"
    
    if let stompbox = stompboxToEdit {
      title = "Edit Stompbox"
      stompboxName.text = stompbox.name
      stompboxType.text = stompbox.type
      stompboxManufacturer.text = stompbox.manufacturer
      
      if let imageFilePath = stompbox.imageFilePath {
        stompboxButton.setImage(UIImage(contentsOfFile: imageFilePath.path), for: .normal)
      }
    }
  }
  
  @IBAction func cancel(_ sender: Any) {
    delegate?.stompboxDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    func isUniqueName(name: String) -> Bool {
      let request = Stompbox.fetchRequest() as NSFetchRequest<Stompbox>
      request.predicate = NSPredicate(format: "name == %@", name)
      do {
        // cache?
        if !(try coreDataStack.moc.fetch(request)).isEmpty {
          alertPromptNotUniqueStompboxName()
          return false
        }
      } catch let error as NSError {
        print(error)
      }
      return true
    }
    
    func alertPromptNotUniqueStompboxName() {
      let alert = UIAlertController(title: "Stompboxes must have unique names",
                                    message: nil,
                                    preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
    }
    
    
    func updateThumbnail() {
      if didPickNewThumbnail {
      let filePath = createUniqueJPGFilePath()
      do {
        try? imageData.write(to: filePath, options: .atomic)
        stompboxToEdit?.imageFilePath = filePath.absoluteURL
        }
      }
    }
    
    if let stompboxToEdit = stompboxToEdit {
      stompboxToEdit.setPropertiesTo(name: stompboxName.text!, type: stompboxType.text!, manufacturer: stompboxManufacturer.text!)
      updateThumbnail()
      delegate?.stompboxDetailViewController(self, didFinishEditing: stompboxToEdit)
    } else {
      if isUniqueName(name: stompboxName.text!) {
        stompboxToEdit = Stompbox.init(entity: NSEntityDescription.entity(forEntityName: "Stompbox", in: coreDataStack.moc)!, insertInto: coreDataStack.moc)
        stompboxToEdit?.setPropertiesTo(name: stompboxName.text!, type: stompboxType.text!, manufacturer: stompboxManufacturer.text!)
        //stompboxToEdit?.makeSetting(numberOfKnobs: 2, numberOfSwitches: 0)
        updateThumbnail()
        
        print("Making setting")
        let setting = Setting(entity: Setting.entity(), insertInto: coreDataStack.moc)
        setting.knobs = Knobs.init()
        setting.knobs?.addKnob()
        setting.knobs?.knobsList[0].continuousValue = 50
        print("Finished making setting")
//        print("Adding a knob to the setting")
//        setting.knobs.addKnob()
//        setting.knobs.knobsList[0].continuousValue = 50
//        print("Number of knobs: \(setting.knobs.knobsList.count)")
//       
        if let stompboxToEdit = stompboxToEdit {
          print("Adding setting to stompbox")
          setting.stompbox = stompboxToEdit
        }
        print("Stompbox has been given a setting")
        print(stompboxToEdit?.settings?.count)
        
        delegate?.stompboxDetailViewController(self, didFinishAdding: stompboxToEdit!)
      }
    }
  }
  
  @IBAction func changePicture(_ sender: UIButton) {
    showPhotoMenu()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return super.tableView(tableView, cellForRowAt: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}


extension StompboxDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func showPhotoMenu() {
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
    let thumbnailPNG = image.resized(withBounds: self.stompboxButton.bounds.size)
    self.imageData = UIImageJPEGRepresentation(thumbnailPNG, 0.4)!
    DispatchQueue.main.async {
      self.stompboxButton.setImage(UIImage(data: self.imageData), for: UIControlState.normal)
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
