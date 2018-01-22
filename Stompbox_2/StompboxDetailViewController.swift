//
//  StompboxDetailViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/17/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData

protocol StompboxDetailViewControllerDelegate: class {
  func stompboxDetailViewControllerDidCancel(_ controller: StompboxDetailViewController)
  func stompboxDetailViewController(_ controller: StompboxDetailViewController, didFinishAdding stompbox: Stompbox)
  func stompboxDetailViewController(_ controller: StompboxDetailViewController, didFinishEditing stompbox: Stompbox)
}

class StompboxDetailViewController: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var stompboxName: UITextField!
  @IBOutlet weak var stompboxType: UITextField!
  @IBOutlet weak var stompboxManufacturer: UITextField!
  @IBOutlet weak var stompboxImage: UIImageView!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  weak var delegate: StompboxDetailViewControllerDelegate?
  var coreDataStack: CoreDataStack!
  var stompboxToEdit: Stompbox?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    doneButton.isEnabled = true
    
    print(delegate.debugDescription)
    navigationItem.largeTitleDisplayMode = .never
    
    if let stompbox = stompboxToEdit {
      title = "Edit Stompbox"
      //doneButton.isEnabled = true
      stompboxName.text = stompbox.name
      stompboxType.text = stompbox.type
      stompboxManufacturer.text = stompbox.manufacturer
      
      if let imageName = stompbox.imageName {
        stompboxImage.image = UIImage(named: imageName)
      }
    }
  }

  @IBAction func cancel(_ sender: Any) {
    delegate?.stompboxDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let stompboxToEdit = stompboxToEdit {  // unwrapping
      stompboxToEdit.name = stompboxName.text!
      stompboxToEdit.type = stompboxType.text!
      stompboxToEdit.manufacturer = stompboxManufacturer.text!
      // stompboxToEdit.imageName = stompboxImage.image.
      
      delegate?.stompboxDetailViewController(self, didFinishEditing: stompboxToEdit)
    } else {
      print("Let's make a new stompbox")
      let newStompbox = Stompbox.init(entity: NSEntityDescription.entity(forEntityName: "Stompbox", in: coreDataStack.moc)!, insertInto: coreDataStack.moc)
      print("New stompbox initialized")
      newStompbox.name = stompboxName.text!
      newStompbox.type = stompboxType.text!
      newStompbox.manufacturer = stompboxManufacturer.text!
      // newStompbox.image =
      print("Stompbox values set")
      delegate?.stompboxDetailViewController(self, didFinishAdding: newStompbox)
      print("Sending stompbox back to delegate")
    }
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
