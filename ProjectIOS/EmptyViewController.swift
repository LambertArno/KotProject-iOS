//
//  EmptyViewController.swift
//  ProjectIOS
//
//  Created by Arno Lambert on 28/12/2016.
//  Copyright © 2016 Arno Lambert. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
    }
}
