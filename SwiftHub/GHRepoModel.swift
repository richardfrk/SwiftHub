//
//  GitHubModel.swift
//  DesafioConcreteSwift23
//
//  Created by Richard Frank on 21/11/16.
//  Copyright © 2016 Richard Frank. All rights reserved.
//

import Foundation

struct GHRepoModel {
    
    /// Repository Objects.
    var id: Int?
    var name: String?
    var html_url: String?
    var stargazers_count: Int?
    var forks_count: Int?
    var description: String?
    
    /// Owner Objects.
    var login: String?
    var avatar_url: String?
    
}
