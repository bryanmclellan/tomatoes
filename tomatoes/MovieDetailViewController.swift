//
//  MovieDetailViewController.swift
//  tomatoes
//
//  Created by Bryan McLellan on 4/11/15.
//  Copyright (c) 2015 Bryan McLellan. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var audienceRatingLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    var movie: NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var titleTemp = movie["title"] as String
        var year = movie["year"] as Int
        titleTemp += " ("
        titleTemp += "\(year)"
        titleTemp += ") "
        var mpaaRating = movie["mpaa_rating"] as String
        
        titleLabel.text = titleTemp
        
        titleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        titleLabel.text! += mpaaRating
        
        var ratingTemp = "Critic Review: "
        var rating = movie["ratings"] as NSDictionary
        ratingTemp += rating["critics_rating"] as String
        var ratingNum = rating["critics_score"] as Int
        ratingTemp += " \(ratingNum)"
        
        ratingLabel.text = ratingTemp
        ratingLabel.font = UIFont.boldSystemFontOfSize(17.0)
        var audienceRatingTemp = "Audience Review: "
        var audienceRating = movie["ratings"] as NSDictionary
        audienceRatingTemp += rating["audience_rating"] as String
        var audienceRatingNum = rating["audience_score"] as Int
        audienceRatingTemp += " \(audienceRatingNum)"
        
        audienceRatingLabel.text = audienceRatingTemp
        audienceRatingLabel.font = UIFont.boldSystemFontOfSize(17.0)
        synopsisLabel.text = movie["synopsis"] as? String
        synopsisLabel.sizeToFit()
        synopsisLabel.textColor = UIColor.whiteColor()
        
        var url = movie.valueForKeyPath("posters.original") as? String
        detailImageView.setImageWithURL(NSURL(string: url!)!)
        
        var range = url!.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        
        if let range = range {
            url = url!.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        detailImageView.setImageWithURL(NSURL(string: url!)!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
