//
//  MovieViewController.swift
//  FlickCollection
//
//  Created by Jamel Peralta Coss on 1/30/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class MovieViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var searchBarController: UISearchController!      //variable for the searchBar within NavigationController
    
    //instance variables
    var movies: [NSDictionary]?
    var filterMovies: [NSDictionary]?
    var apiSection: String!   //variable for section(popular, top rated, etc)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Methods for showing the Collection
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //SearchBar within Navigation Controller(but different from standalone SearchBar)
        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.searchResultsUpdater = self
        searchBarController.searchBar.sizeToFit()
        navigationItem.titleView = searchBarController.searchBar
        searchBarController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        networkRequest()
        
        // Initialize a UIRefreshControl ------> thats the circle for loading and refreshing the app
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Similar to the numberofrowinsection from TableView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let filterMovies = self.filterMovies{
            return filterMovies.count
        }
        else{
            return 0
        }
    }
    
    //This specify what content will have the cell within the CollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
        
        //creates an array of the different contents
        let movie = filterMovies![indexPath.row]
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        //for making sure the app dont crash if there no picture
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = NSURL(string: baseUrl + posterPath)
            let urlRequest = NSURLRequest(URL: posterURL!)
            cell.posterLabel.setImageWithURLRequest(urlRequest, placeholderImage: nil,
                success: {
                    (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) -> Void in
                    if response != nil {
                        cell.posterLabel.alpha = 0
                        cell.posterLabel.image = image
                        UIView.animateWithDuration(0.3, animations: {cell.posterLabel.alpha = 1})
                    }
                    else {
                        cell.posterLabel.image = image
                    }
                },
                failure: {
                    (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) -> Void in })
        }
        
        return cell
    }
    
    //Method for refreching
    func refreshControlAction(refreshControl: UIRefreshControl) {
        //Connect to the API to have the last update
        networkRequest()
        
        //update the collection data source
        refreshControl.endRefreshing()
    }
    
    //Method for searchController
    func updateSearchResultsForSearchController(searchController: UISearchController){
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty {
                self.filterMovies = self.movies
            }
            else {
                self.filterMovies = movies!.filter({ (movie: NSDictionary) -> Bool in
                    if let title = movie["title"] as? String {
                        //If the Data is similar to what your are searching, put it in the array
                        if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                            return  true
                        }
                            //If not, pass
                        else{
                            return false
                        }
                    }
                    return false
                })
            }
            collectionView.reloadData()
        }

    }
    
    //method for requesting Network Data from API
    func networkRequest(){
        SVProgressHUD.show()   //Progress begins
        collectionView.alpha = 0
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(apiSection)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    //responseDictionary Basically is an array that contains all the data from the API
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            //Progress ends
                            SVProgressHUD.dismiss()
                            UIView.animateWithDuration(1.0, animations: {self.collectionView.alpha = 1})
                            
                            //this will assign all the array of data to the instance variable
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            //this one will copy all the data to a filtered one(for use of the searchbar)
                            self.filterMovies = self.movies
                            
                            //reload data after using the API
                            self.collectionView.reloadData()
                    }
                }
        });
        task.resume()
    }

    //Method for passing data to the other ViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Get the details from the selected Cell
        let specificCell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPathForCell(specificCell)
        let specificMovie = filterMovies![indexPath!.row]
        
        //Pass the information to the other Controller
        let detailsViewController = segue.destinationViewController as! DetailsViewController
        detailsViewController.specificMovie = specificMovie
    }
    
}
