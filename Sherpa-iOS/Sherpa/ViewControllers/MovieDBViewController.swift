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
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.view.backgroundColor = .offsetBlack
        self.title = "Title"
        
        // TODO: Clean this up: potential options - double completion or count to the first. Reload once. than reload again ?
        movieController?.getNewMovies(page: 1, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                guard let movies = movies else { return }
                print(movies.count)
                DispatchQueue.main.async {
                    self.title = "Moive count \(movies.count)"
                }
                self.movieController?.fetchImageFrom(movies: movies, completion: { (image) in
                    if let image = image {
                        self.images.append(image)
                        DispatchQueue.main.async {
                            // FIXME: - This is getting called to many times 
                            print("Reloaded! \(self.images.count)")
                            self.kolodaView.reloadData()
                        }
                    }
                })
            case.failure(let error):
                print(error)
            }
        })
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

extension MovieDBViewController: KolodaViewDelegate {
    
    // MARK: - Koloda Delegate
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        UIApplication.shared.open(URL(string: "https://yalantis.com/")!)
    }
}

extension MovieDBViewController: KolodaViewDataSource {
    
    // MARK: - Koloda View DataSource 
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return images.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: images[index])
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("MovieOverlayView", owner: self, options: nil)![0] as? MovieOverlayView
    }
}


