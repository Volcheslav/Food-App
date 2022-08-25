//
//  ViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/3/22.
//  swiftlint:disable all
import RealmSwift
import UIKit

class MainScreenViewController: UIViewController {
    let realm = try! Realm()
    var items: Results<Burgers>!
    let burgerNames = ["Hamburger", "CheesBurger", "BigBurger", "SteakHouse", "Classic", "OldBurger", "BlackHourse"]
    let burgerPrice = [1.49, 2.49, 3.59, 4.29, 7.99, 2.49, 5.29]

    @IBOutlet private weak var sectionNameLabel: UILabel!
    @IBOutlet private weak var mainFirstCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = realm.objects(Burgers.self)
//swiftlint:enable all
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
                
        // Do any additional setup after loading the view.
    }

}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !items.isEmpty else {
            return 0
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainScreenCollectionViewCell
        cell.name = item.name
        cell.price = item.price
        cell.nameImage = item.imageName
        cell.layer.cornerRadius = 30
        cell.layer.masksToBounds = true
        cell.backgroundColor = .darkGray
        return cell
    }

}

extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsInHeigt: CGFloat = 3
        let paddingsHeight: CGFloat = (itemsInHeigt + 1) * 20 + 1
        let avalibalHeight: CGFloat = collectionView.frame.width - paddingsHeight
        let itemWidth = avalibalHeight / itemsInHeigt
        return CGSize(width: itemWidth, height: itemWidth + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
