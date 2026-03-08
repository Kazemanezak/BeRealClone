//
//  FeedViewController.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import UIKit
import ParseSwift

class FeedViewController: UITableViewController {

    private var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 120   // try 140 or 180
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryPosts()
   }

    @IBAction func onLogoutTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: Constants.Notifications.logout, object: nil)
    }

    private func queryPosts() {
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .limit(10)

        query.find { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}
