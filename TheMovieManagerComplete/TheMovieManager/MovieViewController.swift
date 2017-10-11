//
//  MovieViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - MovieViewController: UIViewController

class MovieViewController: UIViewController {
    
    // MARK: Properties
    
    var movieDataSource: MovieDataSource!
    
    // MARK: Outlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var toggleFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var toggleWatchlistButton: UIBarButtonItem!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let movie = movieDataSource.movie
        navigationItem.title = movie.detailedTitle
        
        // load movie state and image
        setActivityIndicatorEnabled(true)
        movieDataSource.loadData(completion: {
            self.setUIEnabled(true)
            self.setActivityIndicatorEnabled(false)
        }, error: { (errorString) in
            self.setUIEnabled(false)
            self.setActivityIndicatorEnabled(false)
            self.alertError(errorString, handler: nil)
        })
    }
    
    // MARK: Actions
            
    @IBAction func mark(_ sender: AnyObject) {    
        guard let tag = sender.tag else { return }
        
        // prepare values
        let listValue = valueForTag(tag)
        let listButton = buttonForTag(tag)
        let listType = listTypeForTag(tag)
        
        // mark movie
        movieDataSource.markForList(listType, toValue: listValue, completion: {
            listButton.tintColor = listValue ? nil : .black
        }) { (errorString) in
            self.alertError(errorString, handler: nil)            
        }
    }
    
    // MARK: Helpers
    
    private func valueForTag(_ tag: Int) -> Bool {
        return tag == 0 ? !movieDataSource.isFavorite : !movieDataSource.isWatchlist
    }
    
    private func buttonForTag(_ tag: Int) -> UIBarButtonItem {
        return tag == 0 ? toggleFavoriteButton : toggleWatchlistButton
    }
    
    private func listTypeForTag(_ tag: Int) -> ListType {
        return tag == 0 ? .favorite : .watchlist
    }
}

// MARK: - MovieViewController (Configure UI)

extension MovieViewController {
    
    private func setUIEnabled(_ enabled: Bool, withImage image: UIImage? = nil) {
        toggleFavoriteButton.isEnabled = enabled
        toggleWatchlistButton.isEnabled = enabled
        
        toggleFavoriteButton.tintColor = (movieDataSource.isFavorite && enabled) ? nil : .black
        toggleWatchlistButton.tintColor = (movieDataSource.isWatchlist && enabled) ? nil : .black
        
        if let image = movieDataSource.posterImage { posterImageView.image = image }
    }
    
    private func setActivityIndicatorEnabled(_ enabled: Bool) {
        activityIndicator.alpha = enabled ? 1.0 : 0.0
        
        if enabled {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
