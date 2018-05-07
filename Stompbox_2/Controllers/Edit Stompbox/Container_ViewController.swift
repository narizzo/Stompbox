//
//  ContainerViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/19/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol ContainerViewControllerDelegate: class {
  func didCancelChanges(_ controller: ContainerViewController)
  func didAcceptChanges(_ controller: ContainerViewController)
}

class ContainerViewController: UIViewController {
  
  // Subviews
  var stackView: UIStackView!
  var stompboxDetailViewController = StompboxDetailViewController()
  var settingCollectionViewController = SettingCollectionViewController()
  
  // Dependencies
  weak var stompboxToEdit: Stompbox? {
    didSet { stompboxDetailViewController.stompboxToEdit = stompboxToEdit }
  }
  weak var coreDataStack: CoreDataStack! {
    didSet { stompboxDetailViewController.coreDataStack = coreDataStack }
  }
  // Delegates
  weak var containerViewControllerDelegate: ContainerViewControllerDelegate!
  weak var stompboxButtonDelegate: StompboxButtonImageDelegate! {
    didSet { stompboxDetailViewController.stompboxButtonDelegate = stompboxButtonDelegate }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("view did load")
    
    view.frame.size = UIScreen.main.bounds.size
    view.layoutIfNeeded()
    
    initializeViewControllers()
    configureToolBarButtons()
    configureNavigationTitle()
  }
  
  override func viewWillLayoutSubviews() {
    print("viewWilllayoutSubviews")
  }
  
  private func initializeViewControllers() {
    // Add views
    stackView = UIStackView(arrangedSubviews: [stompboxDetailViewController.view, settingCollectionViewController.view])
    view.addSubview(stackView)
    
    // Configure Stack View
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false // set false when programmatically instantiating views
    
    // Set delegates
    stompboxDetailViewController.doneBarButtonDelegate = self
    settingCollectionViewController.collectionCellDelegate = self
    
    setLayoutConstraints()
  }
  
  private func setLayoutConstraints() {
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      
      stompboxDetailViewController.view.topAnchor.constraint(equalTo: stackView.topAnchor),
      stompboxDetailViewController.view.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 2/3),
      
      settingCollectionViewController.view.topAnchor.constraint(equalTo: stompboxDetailViewController.view.bottomAnchor),
      settingCollectionViewController.view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
      //settingCollectionViewController.view.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1/3),
      ])
    
    settingCollectionViewController.updateView()
  }
  
  // MARK: - Cancel / Done
  private func configureToolBarButtons() {
    // Add cancel & done bar buttons
    let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelChanges))
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(acceptChanges))
    
    navigationItem.setLeftBarButton(cancelBarButton, animated: true)
    navigationItem.setRightBarButton(doneBarButton, animated: true)
  }
  
  @objc func cancelChanges() {
    containerViewControllerDelegate.didCancelChanges(self)
  }
  
  @objc func acceptChanges() {
    guard stompboxDetailViewController.isStompboxInfoIncomplete() == false else {
      alertUserIncompleteStompboxInformation()
      return
    }
    
    guard stompboxDetailViewController.isSettingInfoIncomplete() == false else {
      alertUserIncompleteSettingInformation()
      return
    }
    
    stompboxDetailViewController.saveChanges()
    containerViewControllerDelegate.didAcceptChanges(self) 
  }
  
  // MARK: - Navigation Title
  private func configureNavigationTitle() {
    //let doneButton = navigationItem.rightBarButtonItem
    if let _ = stompboxToEdit {
      title = "Edit Stompbox"
      //doneButton?.isEnabled = true
    } else {
      title = "Add Stompbox"
      //doneButton?.isEnabled = false
    }
  }
  
  private func alertUserIncompleteStompboxInformation() {
    let alert = UIAlertController(title: "Please enter the Stompbox's name, type, and manufacturer.",
                                  message: nil,
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
  
  private func alertUserIncompleteSettingInformation() {
    let alert = UIAlertController(title: "Please enter a name for each knob.",
                                  message: nil,
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
}

extension ContainerViewController: CollectionCellDelegate {
  func didSelectCollectionCell(_ settingCollectionViewCell: SettingCollectionViewCell) {
    stompboxDetailViewController.stompboxToEdit?.knobLayoutStyle = Int64(settingCollectionViewCell.templateSettingCell.knobLayoutStyle)
    stompboxDetailViewController.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
  }
}
