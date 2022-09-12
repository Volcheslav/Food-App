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
    private let reviewNibName: String = "ReviewTableViewCell"
    private let cellID: String = "ReviewTableViewCell"
    private var reviews: [ParseReviewData]?
    
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
        self.stars.forEach {
            $0.image = UIImage(named: self.starImageName)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.changeColor(_:)))
            $0.addGestureRecognizer(tap)
        }
        self.reviewsTableView.register(UINib(nibName: self.reviewNibName, bundle: nil), forCellReuseIdentifier: self.cellID)
        self.reviewsTableView.rowHeight = UITableView.automaticDimension
        self.reviewsTableView.estimatedRowHeight = 300
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
                // print(self.reviews)
            case .failure(_):
                self.reviews = nil
            }
        }
    }
    // swiftlint:enable empty_enum_arguments
    // MARK: - Unwined segue
    
    @IBAction private func goReviewsMain(_ sender: UIStoryboardSegue) {
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
    
    // MARK: - Stars controller
    
    @objc private func changeColor(_ sender : UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        if self.stars[view.tag].image == UIImage(named: self.starFillImageName) {
            for i in view.tag..<self.stars.count {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        [weak self] in
                        self?.stars[i].alpha = 0
                        self?.stars[i].image = UIImage(named: self!.starImageName)
                        self?.stars[i].alpha = 1
                    }
                    )
                }
            }
        } else {
            for i in 0...view.tag {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        [weak self] in
                        self?.stars[i].alpha = 0
                        self?.stars[i].image = UIImage(named: self!.starFillImageName)
                        self?.stars[i].alpha = 1
                    }
                    )
                }
                
            }
        }
    }
}

// MARK: - Table view extensions

extension ReviewScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reviewsArr = self.reviews else { return 0 }
        return reviewsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID) as? ReviewTableViewCell else {
            return .init() }
        return cell
    }
}
