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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        let detail = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        detail.post = posts[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryPosts()
   }

    @IBAction func onLogoutTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: Constants.Notifications.logout, object: nil)
    }

    private func queryPosts() {
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

        let query = Post.query()    
            .include("user")
            .order([.descending("createdAt")])
            .where("createdAt" >= yesterdayDate)
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
