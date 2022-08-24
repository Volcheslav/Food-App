//
//  ViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/3/22.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet private weak var mainFirstCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainFirstCollection.delegate = self
        mainFirstCollection.dataSource = self
        mainFirstCollection.backgroundColor = .clear
      
        // Do any additional setup after loading the view.
    }

}
