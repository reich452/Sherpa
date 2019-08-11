//
//  MovieDBViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 4/9/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit
import Koloda
import pop

class MovieDBViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var defaultImageView: UIImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var movieController: MovieController?
    var movies: [Movie] = []
    var pageNumber = 1
    fileprivate var dragSpeed: DragSpeed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        setUpUi()
        fetchMovies(pageNumber: pageNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func setUpUi() {
        defaultImageView.clipsToBounds = true
        defaultImageView.layer.cornerRadius = 15
        kolodaView.layer.cornerRadius = 15
        kolodaView.backgroundColor = .primaryColor
        infoButton.makeRoundView()
        view.backgroundColor = .offsetBlack
        title = "New Releases"
        view.backgroundColor = .primaryColor
    }
    
    // MARK: - Actions 
    @IBAction func editBtnTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func didTapInfoBtn(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Change Swipe Speed", message: "Edit the swiping drag speed", preferredStyle: .actionSheet)
        let fastAction = UIAlertAction(title: "Fast", style: .default) { (_) in
            self.dragSpeed = .fast
            self.changeDragSpeed(self.dragSpeed ?? .fast)
        }
        
        let defaultAction = UIAlertAction(title: "Default", style: .default) { (_) in
            self.dragSpeed = .default
            self.changeDragSpeed(self.dragSpeed ?? .default)
        }
        
        let moderateAction = UIAlertAction(title: "Moderate", style: .default) { (_) in
            self.dragSpeed = .moderate
            self.changeDragSpeed(self.dragSpeed ?? .moderate)
        }
        
        let slowAction = UIAlertAction(title: "Slow", style: .default) { (_) in
            self.dragSpeed = .slow
            self.changeDragSpeed(self.dragSpeed ?? .slow)
        }
        
        actionSheet.addAction(fastAction)
        actionSheet.addAction(defaultAction)
        actionSheet.addAction(moderateAction)
        actionSheet.addAction(slowAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func dislikeBtnTapped(_ sender: UIButton) {
        kolodaView.swipe(.left)
    }
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        kolodaView.swipe(.right)
    }
    
    // MARK: - Main
    
    func changeDragSpeed(_ speed: DragSpeed) {
        switch speed {
        case .fast:
            speedLabel.text = "Swiping Speed: Fast"
            kolodaView.reloadData()
        case .default:
            speedLabel.text = "Swiping Speed: Default"
            kolodaView.reloadData()
        case .moderate:
            speedLabel.text = "Swiping Speed: Moderate"
            kolodaView.reloadData()
        case .slow:
            speedLabel.text = "Swiping Speed: Slow"
            kolodaView.reloadData()
        }
    }
    
    func fetchMovies(pageNumber: Int) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        movieController?.getNewMovies(page: pageNumber, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                guard let movies = movies else { return }
                print(movies.count)
                DispatchQueue.main.async {
                    self.title = "New Releases"
                }
                self.movieController?.fetchImageFrom(movies: movies, completion: { (movies) in
                    print("Movies \(Thread.isMainThread)")
                    self.movies = movies
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.kolodaView.reloadData()
                })
            case.failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                }
            }
        })
    }
}



extension MovieDBViewController: KolodaViewDelegate {
    
    // MARK: - Koloda Delegate
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        pageNumber += 1
        kolodaView.resetCurrentCardIndex()
        fetchMovies(pageNumber: pageNumber)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
    }
}

extension MovieDBViewController: KolodaViewDataSource {
    
    // MARK: - Koloda View DataSource 
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return movies.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return dragSpeed ?? .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let kolodaImageView = UIImageView(image: movies[index].image)
        kolodaImageView.clipsToBounds = true
        kolodaImageView.layer.cornerRadius = 15
        return kolodaImageView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        let overlayView = Bundle.main.loadNibNamed("MovieOverlayView", owner: self, options: nil)![0] as? OverlayView
        overlayView?.clipsToBounds = true
        overlayView?.layer.cornerRadius = 15
        return overlayView
    }
}


