//
//  PostModel.swift
//  homeWork_13
//
//  Created by Дмитрий Яковлев on 18.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import Foundation

protocol ModelUpdating: AnyObject{
    func updateModel()
    func showError(error:String)
}

class PostModel{
    
    weak var delegate : ModelUpdating?
    let netModel = NetModel()
    
    private var postArray : [Post] = []
    
    var fromIndex = 0
    var batchSize = 5
    
    // MARK: - init
    init(){
        self.updateModel()
    }
    
    func initModel(t : Bool = true){
        if t{
            postArray = []
            fromIndex = 0
        }
        self.updateModel()
    }
    
    func getModel()->[Post]{
        return postArray
    }
    
    func getModelCount()-> Int{
        return postArray.count
    }
    
    func getPost(at: Int)-> Post? {
        guard at <= postArray.count else{return nil}
        return postArray[at]
    }
    
    // MARK: - addPost
    func addPost(post: Post){
        sendPostReqest(post: post,
                       completion: { post in
                        self.postArray.insert(post, at: 0)
                        self.delegate?.updateModel()
        },
                       failure: { error in
                        DispatchQueue.main.async {
                            self.delegate?.showError(error: error)
                        }
        })
    }
    
    // MARK: - update
    func updateModel(){
        sendGetReqest(
            completion: { tmp in
                self.postArray += tmp
                self.fromIndex = self.postArray.count
                self.delegate?.updateModel()
        },
            failure: { error in
                DispatchQueue.main.async {
                    self.delegate?.showError(error: error)
                }
                    //                print(error)
        })
    }
    
    // MARK: - sendPostReqest
    private func sendPostReqest(post: Post, completion: ((Post) -> Void)?, failure: ((String) -> Void)?) {
        netModel.sendRequest(
            endPoint: "/posts",
            httpMethod: .POST,
            headers: ["Content-Type": "application/json"],
            model: post,
            parseType: Post.self
        ) { result in
            switch result {
            case .error(let error):
                print(error)
                failure?(error)
            case .some(let object):
                dump(object)
                completion?(post)
            }
        }
    }
    
    // MARK: - sendGetReqest
    private func sendGetReqest( completion: (([Post]) -> Void)?, failure: ((String) -> Void)?) {
        let post = Post(userId: -1, id: -1, title: "§", body: "±")
        netModel.sendRequest(
            endPoint: "/posts?_start=\(String(fromIndex))&_limit=\(String(batchSize))",
            httpMethod: .GET,
            headers: ["Content-Type": "application/json"],
            model: post,
            parseType: [Post].self
        ) { result in
            switch result {
            case .error(let error):
                print(error)
                failure?(error)
            case .some(let object):
                dump(object)
                completion?(object)
            }
        }
    }
    
}
