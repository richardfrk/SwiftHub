//
//  MainTableViewController.swift
//  SwiftHub
//
//  Created by Richard Frank on 15/12/16.
//  Copyright © 2016 Richard Frank. All rights reserved.
//

import UIKit
import Kingfisher

class MainTableViewController: UITableViewController {
    
    let notification = CWStatusBarNotification()
    var dataSource = [GHRepoModel]()
    var pageNumber = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Registrando Xib.
        tableView.registerNib(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        
        /// Definindo "nova" margem para o separador.
        tableView.separatorInset.left = 15.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SwiftHub"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        updateUI()
    }
    
    private func updateUI() {
        
        /// Criando objeto API.
        let api = GitHubAPI()
        
        notification.displayNotificationWithMessage("Loading...") {
            
            /// Chamando função de parse.
            api.fetchRepositoryDataFrom(.RepositoryURL, pageNumber: self.pageNumber) { data in
                
                self.dataSource = data
                self.tableView.reloadData()
                self.notification.dismissNotification()
            }
        }
    }
    
    private func getMoreData() {
        
        let api = GitHubAPI()
        var indexPath:[NSIndexPath] = []
        pageNumber += 1
        
        api.fetchRepositoryDataFrom(.RepositoryURL, pageNumber: pageNumber) { data in
            
            let oldValue = self.dataSource.count
            
            self.dataSource += data
            
            for i in oldValue...self.dataSource.count-1 {
                
                indexPath.append(NSIndexPath(forRow: i, inSection: 0))
            }
            
            self.tableView.insertRowsAtIndexPaths(indexPath, withRowAnimation: .None)
            self.notification.dismissNotification()
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MainCell", forIndexPath: indexPath) as!  MainTableViewCell
        
        cell.labelRepoName.text = String(dataSource[indexPath.row].name!) ?? nil
        cell.labelRepoDescription.text = String(dataSource[indexPath.row].description!) ?? nil
        cell.labelRepoStar.text = String(dataSource[indexPath.row].stargazers_count!) ?? nil
        cell.labelRepoFork.text = String(dataSource[indexPath.row].forks_count!) ?? nil
        cell.labelRepoLogin.text = String(dataSource[indexPath.row].login!) ?? nil
        cell.imageRepoAvatar.kf_setImageWithURL(NSURL(string: dataSource[indexPath.row].avatar_url!))
        
        // FIXME
        if (indexPath.row == (dataSource.count - 5)) {
            
            notification.displayNotificationWithMessage("Loading...", completion: {
                self.getMoreData()
            })
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("DetailSegue", sender: indexPath)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc = segue.destinationViewController as! DetailTableViewController
        let row = (sender as! NSIndexPath).row
        vc.dataSegue["login"] = (dataSource[row].login!)
        vc.dataSegue["name"] = (dataSource[row].name!)
    }
    
}
