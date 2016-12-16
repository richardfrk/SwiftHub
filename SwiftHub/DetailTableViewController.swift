//
//  DetailTableViewController.swift
//  SwiftHub
//
//  Created by Richard Frank on 15/12/16.
//  Copyright © 2016 Richard Frank. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    let notification = CWStatusBarNotification()
    var dataSegue:[String:String] = [:]
    var dataSource = [GHPullModel]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Init")
        
    }
    
    deinit {
        print("Deinit")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Registrando Xib.
        tableView.registerNib(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        
        /// Definindo "nova" margem para o separador.
        tableView.separatorInset.left = 15.0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        updateUI()
        
    }
    
    private func updateUI() {
        
        self.title = self.dataSegue["name"]!
        
        /// Criando objeto API.
        let api = GitHubAPI()
        
        notification.displayNotificationWithMessage("Loading...") {
            
            /// Chamando função de parse.
            api.fetchPullRequestDataFrom("https://api.github.com/repos/\(self.dataSegue["login"]!)/\(self.dataSegue["name"]!)/pulls", pageNumber: nil) { data in
                
                self.dataSource = data
                self.tableView.reloadData()
                self.notification.dismissNotification()
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailTableViewCell
        
        cell.labelPullTitle.text = dataSource[indexPath.row].title
        cell.labelPullBody.text = dataSource[indexPath.row].body
        cell.labelPullLogin.text = dataSource[indexPath.row].login
        cell.labelPullCreatedAt.text = dataSource[indexPath.row].created_at
        cell.imagePullAvatar.kf_setImageWithURL(NSURL(string: dataSource[indexPath.row].avatar_url!))
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 115.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        UIApplication.sharedApplication().openURL(NSURL(string:"https://github.com/\(self.dataSegue["login"]!)/\(self.dataSegue["name"]!)/pull/\(dataSource[indexPath.row].number!)")!)
        
    }
    
}
