//
//  ProfileInfoViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/23/22.
//

import UIKit

final class ProfileInfoViewController: UIViewController {
    
    private var profile: ProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionNumber: Int
        switch section {
        case 0:
            sectionNumber = 4
        case 1:
            sectionNumber = 2
        case 2:
            sectionNumber = 5
        default:
            sectionNumber = 0
        }
        return sectionNumber
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeaderTitle: String
        switch section {
        case 0:
            sectionHeaderTitle = "Main"
        case 1:
            sectionHeaderTitle = "Contacts"
        case 2:
            sectionHeaderTitle = "Address"
        default:
            sectionHeaderTitle = ""
        }
        
        return sectionHeaderTitle
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ProfileInfoTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }

}
