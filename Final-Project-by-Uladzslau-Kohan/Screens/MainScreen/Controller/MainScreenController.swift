//
//  ViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/3/22.
//  swiftlint:disable all
import UIKit

class MainScreenViewController: UIViewController {
  
    // MARK: Outlets
    
    @IBOutlet private weak var sectionNameLabel: UILabel!
    @IBOutlet private weak var mainFirstCollection: UICollectionView!
    
    // MARK: LoadFunctions
    
    override func viewDidLoad() {
        super.viewDidLoad()

// swiftlint:enable all
        self.mainFirstCollection.delegate = self
        self.mainFirstCollection.dataSource = self
        self.mainFirstCollection.backgroundColor = .lightGray
        self.mainFirstCollection.layer.cornerRadius = 20
        self.mainFirstCollection.layer.masksToBounds = true
        self.sectionNameLabel.layer.cornerRadius = 10
        self.sectionNameLabel.layer.masksToBounds = true
        self.sectionNameLabel.backgroundColor = .black
        self.sectionNameLabel.text = "Menu"
        self.sectionNameLabel.textColor = .white
        self.sectionNameLabel.adjustsFontSizeToFitWidth = true
                
    }
}

// MARK: Cells configure

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !Menu.shared.getBurgers().isEmpty else {
            return 0
        }
        return Menu.shared.getBurgers().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainScreenCollectionViewCell
        cell.name = Menu.shared.getBurgers()[indexPath.row].name
        cell.price = Menu.shared.getBurgers()[indexPath.row].price
        cell.nameImage = Menu.shared.getBurgers()[indexPath.row].imageName
        cell.layer.cornerRadius = 30
        cell.layer.masksToBounds = true
        cell.backgroundColor = .darkGray
        return cell
    }

}

// MARK: Layoyt

extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsInHeigt: CGFloat = 2
        let paddingsHeight: CGFloat = (itemsInHeigt + 1) * 10 + 1
        let avalibalHeight: CGFloat = collectionView.frame.width - paddingsHeight
        let itemWidth = avalibalHeight / itemsInHeigt
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
