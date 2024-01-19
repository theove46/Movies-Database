//
//  DetailsViewController.swift
//  Movies Database
//
//  Created by BS1098 on 23/7/23.
//

import SDWebImage
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        backgroundBlurEffect()
        
        getMoviePoster()
        setMovieDataToView()
    }
    
    
    func getMoviePoster() {
        guard let posterPath = movie?.poster_path else {
            return
        }
        
        posterImageView.sd_setImage(with: URL(string: Constants.posterBaseURL+posterPath), placeholderImage: UIImage(systemName: "photo"), options: .continueInBackground, completed: nil)
        
        backGroundImageView.sd_setImage(with: URL(string: Constants.posterBaseURL+posterPath), placeholderImage: UIImage(systemName: "photo"), options: .continueInBackground, completed: nil)
    }
    
    
    func setMovieDataToView() {
        guard let movie = movie else {
            return
        }
        
        nameLabel.text = movie.title
        releaseDateLabel.text = movie.release_date
        descriptionLabel.text = movie.overview
        popularityLabel.text = movie.popularity.string
        ratingLabel.text = movie.vote_average.string
        votesLabel.text = movie.vote_count.string
    }
    
    
    func backgroundBlurEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 1)
    }
}

