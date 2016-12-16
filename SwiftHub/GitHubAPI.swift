//
//  GitHubAPI.swift
//  DesafioConcreteSwift23
//
//  Created by Richard Frank on 21/11/16.
//  Copyright © 2016 Richard Frank. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum SourceURL: String {
    case RepositoryURL = "https://api.github.com/search/repositories?q=language:Swift&sort=stars"
}

class GitHubAPI {
    
    private func requestAlamofireJSONFrom(url url: String, pageNumber:Int?, completionHandler: (JSON -> ())) {
        
        var pageParameter:[String:AnyObject] = [:]
        
        if pageNumber != nil {
            pageParameter = ["page":pageNumber!]
        }
        
        Alamofire.request(.GET, url, parameters: pageParameter).responseJSON { response in
            
            if let value = response.result.value {
                
                let data = JSON(value)
                completionHandler(data)
                
            } else {
                
                print("Problem with Alamofire request.")
            }
        }
    }
    
    func fetchRepositoryDataFrom(url: SourceURL, pageNumber:Int?, completionHandler: ([GHRepoModel] -> ()))  {
        
        requestAlamofireJSONFrom(url: url.rawValue, pageNumber: pageNumber) { json in
            
            let model = self.parseRepositoryDataFrom(json: json)
            completionHandler(model)
        }
    }
    
    private func parseRepositoryDataFrom(json json: JSON) -> [GHRepoModel] {
        
        var model = GHRepoModel()
        var modelArray = [GHRepoModel]()
        
        let jsonItemsCounter = json["items"].array?.count
        
        for item in 0..<jsonItemsCounter! {
            
            /// Repo
            model.name = json["items"][item]["name"].stringValue
            model.description = json["items"][item]["description"].stringValue
            model.stargazers_count = json["items"][item]["stargazers_count"].intValue
            model.forks_count = json["items"][item]["forks_count"].intValue
            
            /// Owner
            model.login = json["items"][item]["owner"]["login"].stringValue
            model.avatar_url = json["items"][item]["owner"]["avatar_url"].stringValue
            
            modelArray.append(model)
        }
        
        return modelArray
    }
    
    func fetchPullRequestDataFrom(url: String, pageNumber: Int?, completionHandler: ([GHPullModel] -> ()))  {
        
        requestAlamofireJSONFrom(url: url, pageNumber: pageNumber) { json in
            
            let model = self.parsePullRequestDataFrom(json: json)
            completionHandler(model)
        }
    }
    
    private func parsePullRequestDataFrom(json json: JSON) -> [GHPullModel] {
        
        var model = GHPullModel()
        var modelArray = [GHPullModel]()
        
        let jsonCounter = json.array?.count
        
        for item in 0..<jsonCounter! {
            
            /// Pull Request
            model.number = json[item]["number"].stringValue
            model.title = json[item]["title"].stringValue
            model.login = json[item]["user"]["login"].stringValue
            model.body = json[item]["body"].stringValue
            model.created_at = json[item]["created_at"].stringValue
            model.avatar_url = json[item]["user"]["avatar_url"].stringValue
            
            modelArray.append(model)
        }
        
        return modelArray
    }
    
    
}
