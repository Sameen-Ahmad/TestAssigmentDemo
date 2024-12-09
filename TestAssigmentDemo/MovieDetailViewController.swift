//
//  MovieDetailViewController.swift
//  TestAssigmentDemo
//
//  Created by ginger on 05/12/24.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!

    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movie = movie else { return }
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        if let posterPath = movie.posterPath {
            let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
            posterImageView.kf.setImage(with: URL(string: imageUrl))
        }
        stutusOfMovie()
        
        
    }
    
    func stutusOfMovie(){
        guard let movie = movie else { return }
        if CoreDataManager.shared.isFavorite(movieId: movie.id) {
            favoriteButton.setTitle("Remove from Favorites", for: .normal)
        } else {
            favoriteButton.setTitle("Add to Favorites", for: .normal)
        }
    }
    
    
    
    
    func saveSeenMovie(){
                    guard let movie = movie else { return }
                    if CoreDataManager.shared.isFavorite(movieId: movie.id) {
                        CoreDataManager.shared.removeFavorite(movieId: movie.id)
                    } else {
                        CoreDataManager.shared.saveFavorite(movie: movie)
                    }
    }
    
    private func updateFavoriteButton() {
           guard let movie = movie else { return }
           if CoreDataManager.shared.isFavorite(movieId: movie.id) {
               favoriteButton.setTitle("Remove from Favorites", for: .normal)
           } else {
               favoriteButton.setTitle("Add to Favorites", for: .normal)
           }
       }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
       
        saveSeenMovie()
        updateFavoriteButton()
        }

    
    
    @IBAction func favoriteListTapped(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
           guard let favoritesVC = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController else {
               print("FavoritesViewController not found in storyboard.")
               return
           }

           // Navigate to FavoritesViewController
           self.navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
}
