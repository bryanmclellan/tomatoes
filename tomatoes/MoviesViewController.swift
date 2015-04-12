//
//  MoviesViewController.swift
//  tomatoes
//
//  Created by Bryan McLellan on 4/8/15.
//  Copyright (c) 2015 Bryan McLellan. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var movies: [NSDictionary]! = [NSDictionary]()
    var filtered: [NSDictionary]! = []
    let refreshControl = UIRefreshControl()
    var searchActive = false

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        var hud = MBProgressHUD.showHUDAddedTo(tableView, animated: true)
        hud.labelText = "Loading Movies"
        
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5")!
        
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if(data == nil){
                NSLog("we got a network error")
                var errorLabel = UILabel(frame: CGRect(x: 100, y: 0, width: 320, height: 30))
                errorLabel.text = "Network Error"
                errorLabel.textColor = UIColor.whiteColor()
                var errorView = UIView(frame: CGRect(x: 0, y: 44, width: 320, height: 50))
                errorView.backgroundColor = UIColor.orangeColor()
                errorView.addSubview(errorLabel)
                self.tableView.addSubview(errorView)
            }
            else{
            var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            
            self.movies = json["movies"] as [NSDictionary]
            self.tableView.reloadData()
                MBProgressHUD.hideHUDForView(self.tableView, animated: true)
                
            }
            
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        var textSearchField = searchBar.valueForKey("_searchField") as UITextField
        textSearchField.clearButtonMode = UITextFieldViewMode.Never
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.whiteColor()
        nav?.barTintColor = UIColor(red: 255/255.0, green: 168/255.0, blue: 84.0/255.0, alpha: 1.0)
        let navImageView = UIImageView(frame: CGRect(x: 70, y: 0, width: 180, height: 40))
        var url = "http://d3biamo577v4eu.cloudfront.net/static/images/logos/rtlogo.png"
        navImageView.setImageWithURL(NSURL(string: url))
        nav?.addSubview(navImageView)
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false;
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
       
        filtered = movies.filter({ (text) -> Bool in
            let tmp: NSString = text["title"] as String
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        if(searchText == ""){
            searchBar.resignFirstResponder()
            searchActive = false
        }
        
        self.tableView.reloadData()
    }
    
    
    
    func onRefresh(){
        
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5")!
        
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if(data == nil){
                NSLog("we got a network error")
                var errorLabel = UILabel(frame: CGRect(x: 100, y: 0, width: 320, height: 30))
                errorLabel.text = "Network Error"
                errorLabel.textColor = UIColor.whiteColor()
                var errorView = UIView(frame: CGRect(x: 0, y: 44, width: 320, height: 50))
                errorView.backgroundColor = UIColor.orangeColor()
                errorView.addSubview(errorLabel)
                self.tableView.addSubview(errorView)
            }
            else{
                var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                
                self.movies = json["movies"] as [NSDictionary]
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as MovieCell
        
        var movie = movies[indexPath.row]
        NSLog("at indexPath searchActive \(indexPath.row)")
        if (searchActive){
            NSLog("at indexPath searchActive \(indexPath.row)")
            movie = filtered[indexPath.row]
        }
        
        
        cell.titleLabel.text = movie["title"] as? String
        cell.titleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var url = movie.valueForKeyPath("posters.thumbnail") as? String
        cell.posterView.setImageWithURL(NSURL(string: url!)!)
        return cell
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        NSLog("navigating")
        var movieDetailViewController = segue.destinationViewController as MovieDetailViewController
        
        var cell = sender as UITableViewCell

        var indexPath = tableView.indexPathForCell(cell)!
        
        if(searchActive){
            movieDetailViewController.movie = filtered[indexPath.row]
        }
        else{
            movieDetailViewController.movie = movies[indexPath.row]
        }
        
    }


}
