//
//  DetailsViewController.swift
//  FlickCollection
//
//  Created by Jamel Peralta Coss on 1/31/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var posterLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoBoxView: UIView!
    
    //Popularity
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    
    //instance variables
    var specificMovie: NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set UIimage for popular stats
        popularStars()
        calculatingPopularity()
        
        //Setting the scrollView
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoBoxView.frame.origin.y + infoBoxView.frame.height)
        
        fillLabels()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillLabels(){
        let movieName = specificMovie!["title"] as! String
        let movieDescription = specificMovie!["overview"] as! String
        let pathImage = specificMovie!["poster_path"] as! String
        let baseLowResUrl = "http://image.tmdb.org/t/p/w45"
        let posterLowResUrl = NSURL(string: baseLowResUrl + pathImage)
        let baseHiResUrl = "http://image.tmdb.org/t/p/original"
        let posterHiResUrl = NSURL(string: baseHiResUrl + pathImage)
        
        titleLabel.text = movieName
        descriptionLabel.text = movieDescription
        //for testing the low and high res time
        posterLabel.setImageWithURL(posterLowResUrl!)
        posterLabel.setImageWithURL(posterHiResUrl!)
    }
    
    func popularStars(){
        star1.alpha = 0;
        star1.image = UIImage(named: "popularstars")
        star2.alpha = 0
        star2.image = UIImage(named: "popularstars")
        star3.alpha = 0
        star3.image = UIImage(named: "popularstars")
        star4.alpha = 0
        star4.image = UIImage(named: "popularstars")
        star5.alpha = 0
        star5.image = UIImage(named: "popularstars")
    }
    
    func calculatingPopularity(){
        let popularity = specificMovie!["popularity"] as! Double
        if(popularity >= 0.0){
            star1.alpha = 1
        }
        if(popularity > 2.0){
            star2.alpha = 1
        }
        if(popularity > 4.0){
            star3.alpha = 1
        }
        if(popularity > 6.0){
            star4.alpha = 1
        }
        if(popularity > 8.0){
            star5.alpha = 1
        }

    }
    
}
