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
  
  weak var stompboxToEdit: Stompbox?
  weak var stompboxButtonDelegate: StompboxButtonDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.purple
    
    configureTableView()
    
    let stompboxNib = UINib(nibName: Constants.stompboxNib, bundle: nil)
    tableView.register(stompboxNib, forCellReuseIdentifier: Constants.stompboxCellReuseID)
    
    let settingNib = UINib(nibName: Constants.settingCellSimpleNib, bundle: nil)
    tableView.register(settingNib, forCellReuseIdentifier: Constants.simpleSettingReuseID)
  }
  
  private func configureTableView() {
    tableView.isScrollEnabled = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = black
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    if indexPath.row == 0 {
      cell = tableView.dequeueReusableCell(withIdentifier: Constants.stompboxCellReuseID, for: indexPath)
      if let stompboxCell = cell as? StompboxCell {
        stompboxCell.deltaButton.hide()
        if let stompboxToEdit = stompboxToEdit {
          stompboxCell.nameLabel.text = stompboxToEdit.name
          stompboxCell.typeLabel.text = stompboxToEdit.type
          stompboxCell.manufacturerLabel.text = stompboxToEdit.manufacturer
          stompboxCell.isEditable = true
          stompboxCell.stompboxButton.delegate = stompboxButtonDelegate
        }
      }
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: Constants.simpleSettingReuseID, for: indexPath)
      if let simpleCell = cell as? SimpleSettingCell {
        if let stompboxToEdit = stompboxToEdit {
          simpleCell.knobLayoutStyle = stompboxToEdit.knobLayoutStyle
          
          // Load knobNameLabels into the SimpleSettingView
          if let settings = stompboxToEdit.settings {
            if let setting = settings.firstObject as? Setting {
              if let knobs = setting.knobs {
                var i: Int = 0
                while i < knobs.count && i < simpleCell.knobViews.count {
                  if let knob = knobs[i] as? Knob {
                    simpleCell.knobViews[i].knobNameLabel.text = knob.name
                    print("Knob name: \(knob.name)")
                  }
                  i += 1
                }
              }
            }
          }
        }
      }
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return Constants.stompboxCellHeight
    } else {
      return Constants.settingCellHeight
    }
  }
  
  // shouldn't need this because StompboxCell isn't highlightable
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // MARK: - Table view delegate
  
}

/*
 // MARK: - Stompbox Outlets
 @IBOutlet weak var stompboxCell: UITableViewCell!
 @IBOutlet weak var stompboxName: UITextField!
 @IBOutlet weak var stompboxType: UITextField!
 @IBOutlet weak var stompboxManufacturer: UITextField!
 @IBOutlet weak var stompboxButton: UIButton!
 
 // MARK: - Other Outlets
 @IBOutlet weak var doneButton: UIBarButtonItem!
 @IBOutlet weak var settingCell: SimpleSettingCell!  // needed?
 
 weak var delegate: StompboxDetailViewControllerDelegate?
 weak var coreDataStack: CoreDataStack!
 weak var stompboxToEdit: Stompbox?
 
 let imagePicker = UIImagePickerController()
 var imageData = Data()
 var didPickNewThumbnail = false
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 print("StompboxDetailViewController did load")
 
 stompboxName.allowsEditingTextAttributes = false
 navigationController?.navigationBar.barTintColor = UIColor.black  // doesn't work????
 tableView.backgroundColor = black
 stompboxCell.backgroundColor = black
 
 // text background color
 stompboxName.backgroundColor = black
 stompboxType.backgroundColor = black
 stompboxManufacturer.backgroundColor = black
 stompboxButton.backgroundColor = black
 
 // text color
 stompboxName.textColor = blue
 stompboxType.textColor = blue
 stompboxManufacturer.textColor = blue
 
 // placeholder text and color
 stompboxName.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor: lightestGray])
 stompboxType.attributedPlaceholder = NSAttributedString(string: "Type", attributes: [NSAttributedStringKey.foregroundColor: lightestGray])
 stompboxManufacturer.attributedPlaceholder = NSAttributedString(string: "Manufacturer", attributes: [NSAttributedStringKey.foregroundColor: lightestGray])
 
 // clear text on edit
 stompboxName.clearsOnBeginEditing = true
 stompboxType.clearsOnBeginEditing = true
 stompboxManufacturer.clearsOnBeginEditing = true
 
 // additional setup
 doneButton.isEnabled = true
 stompboxButton.imageView?.contentMode = .scaleAspectFit
 navigationItem.largeTitleDisplayMode = .never
 title = "Add Stompbox"
 
 if let stompbox = stompboxToEdit {
 title = "Edit Stompbox"
 stompboxName.text = stompbox.name
 stompboxType.text = stompbox.type
 stompboxManufacturer.text = stompbox.manufacturer
 
 //settingCell.knobLayoutStyle = stompbox.knobLayoutStyle
 
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
 let alert = UIAlertController(title: "A Stompbox already has this name",
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
 
 guard stompboxName.text!.isEmpty == false else {
 return
 }
 if let stompboxToEdit = stompboxToEdit {
 stompboxToEdit.setPropertiesTo(name: stompboxName.text!, type: stompboxType.text!, manufacturer: stompboxManufacturer.text!)
 updateThumbnail()
 delegate?.stompboxDetailViewController(self, didFinishEditing: stompboxToEdit)
 } else {
 if isUniqueName(name: stompboxName.text!) {
 stompboxToEdit = Stompbox.init(entity: NSEntityDescription.entity(forEntityName: "Stompbox", in: coreDataStack.moc)!, insertInto: coreDataStack.moc)
 stompboxToEdit?.setPropertiesTo(name: stompboxName.text!, type: stompboxType.text!, manufacturer: stompboxManufacturer.text!)
 updateThumbnail()
 delegate?.stompboxDetailViewController(self, didFinishAdding: stompboxToEdit!)
 }
 }
 }
 
 @IBAction func changePicture(_ sender: UIButton) {
 showPhotoMenu()
 }
 
 //  // MARK: - Table view data source
 //  override func numberOfSections(in tableView: UITableView) -> Int {
 //    return 1
 //  }
 //
 //  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 //    return 1
 //  }
 //
 //  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 //    return super.tableView(tableView, cellForRowAt: indexPath)
 //  }
 //
 //  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 //    return 200
 //  }
 //
 //  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 //    tableView.deselectRow(at: indexPath, animated: true)
 //  }
 
 }
 
 // MARK: - StompboxDetail VC
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
 
 */
