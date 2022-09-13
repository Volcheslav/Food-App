//
//  ReviewScreenViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/12/22.
//
import ParseSwift
import UIKit

final class ReviewScreenViewController: UIViewController {
    
    private let starImageName: String = "star"
    private let starFillImageName: String = "starFill"
    private let modalStoryboardName: String = "ReviewDetailsScreen"
    private let modalVCIdentifier: String = "reviewDetails"
    private var reviews: [ParseReviewData]?
    
    private let reviewNibName: String = "ReviewCell"
    private let cellID: String = "ReviewCell"
 
    @IBOutlet private weak var addReviewButton: UICustomButton!
    @IBOutlet private weak var star1Image: UIImageView!
    @IBOutlet private weak var star2Image: UIImageView!
    @IBOutlet private weak var star3Image: UIImageView!
    @IBOutlet private weak var star4Image: UIImageView!
    @IBOutlet private weak var star5Image: UIImageView!
    @IBOutlet private weak var reviewsTableView: UITableView!
    
    private var stars: [UIImageView] {
        [
            self.star1Image,
            self.star2Image,
            self.star3Image,
            self.star4Image,
            self.star5Image
        ]
    }
    
    @IBAction private func addReviewAction(_ sender: UICustomButton) {
        self.showReviewAddPage()
    }
    
    // MARK: - Load functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        self.addReviewButton.setTitle(("ADD_REVIEW")§, for: .normal)
      
        self.reviewsTableView.rowHeight = UITableView.automaticDimension
        self.reviewsTableView.estimatedRowHeight = 600
        
        self.reviewsTableView.register(UINib(nibName: self.reviewNibName, bundle: nil), forCellReuseIdentifier: self.cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            self.getReviews()
    }
    
    // MARK: - Get user review Query
    // swiftlint:disable empty_enum_arguments
    private func getReviews() {
        let query = ParseReviewData.query()
        query.find { result in
            switch result {
            case .success(let tempOrder):
                self.reviews = tempOrder
                self.reviewsTableView.reloadData()
                self.showStars()
                // print(self.reviews)
            case .failure(_):
                self.reviews = nil
            }
        }
    }
    // swiftlint:enable empty_enum_arguments
    // MARK: - Unwined segue
    
    @IBAction private func goReviewsMain(_ sender: UIStoryboardSegue) {
        self.getReviews()
    }
    
    // MARK: - Show modal vc
    
    private func showReviewAddPage() {
        let storybord = UIStoryboard(name: self.modalStoryboardName, bundle: nil)
        guard let viewController = storybord.instantiateViewController(identifier: self.modalVCIdentifier) as? ReviewDetailsViewController else {
            return
        }
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        show(viewController, sender: nil)
    }
    
    // MARK: - Stars
    
    private func showStars() {
        guard let reviewArr = self.reviews else { return }
        let marksAvg = Double(reviewArr.map { $0.mark ?? 0 }.reduce(0, +)) / Double(reviewArr.count)
        let stars = Int(marksAvg.rounded())
        self.stars.prefix(stars).forEach { $0.image = UIImage(named: self.starFillImageName) }
        self.stars.suffix(5 - stars).forEach { $0.image = UIImage(named: self.starImageName) }
    }
}

// MARK: - Table view extensions

extension ReviewScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reviewsArr = self.reviews else { return 0 }
        return reviewsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID) as? ReviewCell else {
            return .init() }
        guard let reviewsArray = self.reviews else { return .init() }
        cell.username = reviewsArray[indexPath.row].username
        cell.mark = reviewsArray[indexPath.row].mark
        cell.review = reviewsArray[indexPath.row].reviewText
        cell.isUserInteractionEnabled = false
        return cell
    }
}
