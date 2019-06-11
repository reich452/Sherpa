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
    
    @IBOutlet weak var kolodaView: KolodaView!
    var movieController: MovieController?
    var movies: [Movie] = []
    var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.layer.cornerRadius = 15
        self.view.backgroundColor = .offsetBlack
        self.title = "Title"
        fetchMovies(pageNumber: pageNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Actions 
    
    @IBAction func dislikeBtnTapped(_ sender: UIButton) {
        kolodaView.swipe(.left)
    }
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        kolodaView.swipe(.right)
    }
    
    // MARK: - Main
    
    func fetchMovies(pageNumber: Int) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        movieController?.getNewMovies(page: pageNumber, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                guard let movies = movies else { return }
                print(movies.count)
                DispatchQueue.main.async {
                    self.title = "Moive count \(movies.count)"
                }
                self.movieController?.fetchImageFrom(movies: movies, completion: { (movies) in
                    print("Movies \(Thread.isMainThread)")
                    self.movies = movies
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.kolodaView.reloadData()
                })
            case.failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
        UIApplication.shared.open(URL(string: "https://www.themoviedb.org/")!)
    }
}

extension MovieDBViewController: KolodaViewDataSource {
    
    // MARK: - Koloda View DataSource 
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return movies.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
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


