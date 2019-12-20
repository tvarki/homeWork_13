//
//  ViewController.swift
//  homeWork_13
//
//  Created by Дмитрий Яковлев on 18.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    private var postModel = PostModel()
    let postCellIdentifier = "PostCell"
    var addButton : UIBarButtonItem?
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Setup
    func setup(){
        
        postModel.delegate = self
        
        configurePullToRefresh()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib(nibName: postCellIdentifier, bundle: nil), forCellReuseIdentifier: postCellIdentifier)
        
        
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        addButton?.isEnabled = true
        
        navigationItem.rightBarButtonItems = [addButton!]
        navigationItem.setHidesBackButton(true, animated:true);
        
    }
    
    
    // MARK: - Add Button tapped
    @objc func addTapped() {
        //
        let controller = AddViewController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - PullToRefresh
    private func configurePullToRefresh() {
        refreshControl.tintColor = UIColor.blue
        refreshControl.attributedTitle = NSAttributedString(string: "Скачиваем таблицу")
        
        if #available(iOS 10.0, *) {
            myTableView.refreshControl = refreshControl
        } else {
            myTableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        postModel.initModel()
    }
    
    func makeAlert(title: String , text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

// MARK: - TableView Delegate extension
extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            postModel.initModel(t:false)
        }
    }
    
    
}

// MARK: - TableView Data Sourse extension
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postModel.getModelCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier, for: indexPath) as? PostCell ,
            let post = postModel.getPost(at: indexPath.row) else {return PostCell()}
        cell.setPost(post: post)
        return cell
    }
    
    
}

// MARK: - Add button delegate extension
extension ViewController: AddViewDelegate{
    func addData(post: Post) {
        postModel.addPost(post: post)
    }
    
}

extension ViewController: ModelUpdating{
    func showError(error: String) {
            self.makeAlert(title: "Внимание", text: "Ошибка во время работы с сетью: \n \(error)")
    }
    
    func updateModel() {
        DispatchQueue.main.async {
            self.myTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    
    
}
