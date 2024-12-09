//
//  MovieSearchViewController.swift
//  TestAssigmentDemo
//
//  Created by ginger on 05/12/24.
//

import UIKit
import Kingfisher

class MovieSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            // Ensure there is a search query
            guard let query = searchBar.text, !query.isEmpty else {
                print("Search query is empty.")
                return
            }
            
            // Dismiss the keyboard
            searchBar.resignFirstResponder()
            
            // Call the MovieService to perform the search
            MovieService.shared.searchMovies(query: query) { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                }
            }
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        if let posterPath = movie.posterPath {
            let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
            cell.imageView?.kf.setImage(with: URL(string: imageUrl))
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
        detailVC.movie = movie
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
