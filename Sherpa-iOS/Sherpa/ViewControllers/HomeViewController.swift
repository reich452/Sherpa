//
//  HomeViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setUpUI() {
        homeCollectionView.backgroundColor = .primaryColor
        navigationController?.navigationBar.prefersLargeTitles = true

    }
}

// MARK: - DataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Constants.dataBaseImages.count
        case 1:
            return Constants.funApiImages.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.dataBaseCell, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self 
        switch indexPath.section {
        case 0:
            let dataBaseImage = Constants.dataBaseImages[indexPath.row]
            cell.logoImageView.image = dataBaseImage
            return cell
        case 1:
            let apiImage = Constants.funApiImages[indexPath.row]
            cell.logoImageView.image = apiImage
        default:
            return cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.homeSectionHeader, for: indexPath) as? SectionHeaderCollectionReusableView else { return UICollectionReusableView() }
            
            header.setNeedsLayout()
            if indexPath.section == 0 {
                header.sectionHeaderLabel.text = "Choose Your Backend"
            } else {
                header.sectionHeaderLabel.text = "Voting"
            }
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - FlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // number of Col.
        let nbCol = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(nbCol - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(nbCol))
        return CGSize(width: size, height: size)
    }
}

// MARK: - Custom Delegate

extension HomeViewController: HomeCollectionViewCellDelegate {
    // TODO: - Clean up
    func didTapCellButton(cell: HomeCollectionViewCell) {
        guard let indexPath = self.homeCollectionView.indexPath(for: cell) else { return }
        if indexPath.row == 0 && indexPath.section == 0  {
            self.tabBarController?.selectedIndex = 1
        } else if indexPath.row == 1 && indexPath.section == 0 {
            self.tabBarController?.selectedIndex = 2
        } else if indexPath.row == 0 && indexPath.section == 1 {
            let vc = MovieDBViewController.instantiate(fromAppStoryboard: .MovieDB)
            vc.movieController = MovieController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = VoteViewController.instantiate(fromAppStoryboard: .Vote)
            vc.voteController = VoteController()
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
}
