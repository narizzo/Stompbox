//
//  ContainerViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/19/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  @IBOutlet weak var stackView: UIStackView!
  
  var stompboxDetailViewController = StompboxDetailViewController()
  var settingDetailViewController = SettingDetailViewController()
  var settingCollectionViewController = SettingCollectionViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeViewControllers()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func initializeViewControllers() {
    // Add views
    stackView.addArrangedSubview(stompboxDetailViewController.view)
    //// stackView.addArrangedSubview(settingDetailViewController.view)
    stackView.addArrangedSubview(settingCollectionViewController.view)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
