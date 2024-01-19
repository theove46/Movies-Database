//
//  ViewController.swift
//  Movies Database
//
//  Created by BS1098 on 23/7/23.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var genreList = [Genre]()
    var xOffsets: [IndexPath: CGFloat] = [:]
    var movieData: [IndexPath: MovieCollectionResponse] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The Movie Database"
        tableView.prefetchDataSource = self
        getGenreList()
    }
    
    //fetching genre list from api
    func getGenreList(){
        APIService.API.getGenreList{
            [weak self] jsonPayload in
            
            guard let weakSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                weakSelf.genreList = jsonPayload.genres
                weakSelf.tableView.reloadData()
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        if let movies = movieData[indexPath] {
            
            //print("Accessing from movieData")
            cell.cellConfiguration(genre: genreList[indexPath.row], movies: movies)
            cell.parent = self
            return cell
            
        }
        
        APIService.API.getMoviesByGenre(genreList[indexPath.row].id){
            [weak self] jsonPayload in
            
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.movieData[indexPath] = jsonPayload
            DispatchQueue.main.async {
                cell.cellConfiguration(genre: weakSelf.genreList[indexPath.row], movies: jsonPayload)
            }
            
        }
        
        cell.parent = self
        //print("Calling API to get movieData")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270.0
    }
    
    
    //these 2 methods are used to keep track of the scroll position of the collection view because dequeue reusable method kept scrolling multiple rows at once
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        xOffsets[indexPath] = (cell as? TableViewCell)?.collectionView.contentOffset.x
        //print("storing data")
        movieData[indexPath]?.page = (cell as? TableViewCell)!.pageCount
        movieData[indexPath]?.results.append(contentsOf: (cell as? TableViewCell)!.movieList)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TableViewCell)?.collectionView.contentOffset.x = xOffsets[indexPath] ?? 0
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            print("Prefetching Table Data: \(indexPath.row)")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
                return
            }
            
            if let movies = movieData[indexPath] {
                
                cell.cellConfiguration(genre: genreList[indexPath.row], movies: movies)
                cell.parent = self
                return
                
            }
            
            APIService.API.getMoviesByGenre(genreList[indexPath.row].id){
                [weak self] jsonPayload in
                
                guard let weakSelf = self else {
                    return
                }
                
                weakSelf.movieData[indexPath] = jsonPayload
                DispatchQueue.main.async {
                    cell.cellConfiguration(genre: weakSelf.genreList[indexPath.row], movies: jsonPayload)
                }
                
            }
            
            cell.parent = self
            
            return
        }
    }

}


