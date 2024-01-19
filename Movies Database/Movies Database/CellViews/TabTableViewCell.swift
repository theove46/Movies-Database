//
//  TabTableViewCell.swift
//  Movies Database
//
//  Created by BS1098 on 23/7/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var genreId: Int?
    var movieList = [Movie]()
    var parent: UIViewController?
    var totalPage = 1
    var pageCount = 2
    var fetching = false
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //delegating
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //fetching movie collection and the data from 1st page of the api
    func getMovieData(){
        guard let genreId = genreId else {
            return
        }
        
        APIService.API.getMoviesByGenre(genreId){
            [weak self] jsonPayload in
            
            guard let weakSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                weakSelf.totalPage = jsonPayload.total_pages
                weakSelf.movieList = jsonPayload.results
                weakSelf.collectionView.reloadData()
            }
        }
    }
    
    func cellConfiguration(genre: Genre, movies: MovieCollectionResponse){
        selectionStyle = .none
        backgroundColor = UIColor.clear
        titleTextLabel.text = genre.name
        genreId = genre.id
        movieList = movies.results
        totalPage = movies.total_pages
        if (movies.page > 1){
            pageCount = movies.page
        }
        collectionView.reloadData()
        
        awakeFromNib()
    }
    
}

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let posterPath = movieList[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        
        cell.cellConfiguration(posterPath: posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //pushing detail view when selected
        if let vc = storyboard.instantiateViewController(withIdentifier: "details") as? DetailViewController {
            vc.movie = movieList[indexPath.row]
            parent?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension TableViewCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            print("Prefetching \(titleTextLabel.text!) Cell: \(indexPath.row)")
            if movieList.count-10 == indexPath.row {
                if !fetching {
                    self.fetching = true
                    self.fetchData()
                    //print("Page Count: \(pageCount)")
                }
                self.fetching = false
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? CollectionViewCell else {
                return
            }
            
            guard let posterPath = movieList[indexPath.row].poster_path else {
                return
            }
            
            cell.cellConfiguration(posterPath: posterPath)
            
        }
    }
    
    
    func fetchData() {
        if pageCount <= totalPage {
            guard let genreId = genreId else {
                return
            }
            
            print("API Called")
            //calling api with pagination
            APIService.API.getMoviesByPage(genreId, pageCount){
                [weak self] jsonPayload in
                
                guard let weakSelf = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    weakSelf.movieList.append(contentsOf: jsonPayload.results)
                    
//                    //changed here to only insert items rather than reloading the whole collectionView
//                    let count = (weakSelf.pageCount-1)*20
//                    let indexPaths = Array(count..<count+20).map { IndexPath(item: $0, section: 0) }
//                    weakSelf.collectionView.insertItems(at: indexPaths)
                    
                    weakSelf.collectionView.reloadData()
                    
                    weakSelf.pageCount += 1
                }
            }
        }
    }

}
