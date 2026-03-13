//
//  PostDetailViewController.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/13/26.
//

import UIKit
import ParseSwift

class PostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!

    var post: Post!
    private var comments: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        // Safety: make sure post exists
        guard let post = post else {
            showAlert(description: "Post not found.")
            navigationController?.popViewController(animated: true)
            return
        }

        captionLabel.text = post.caption ?? ""

        // Load post image
        if let url = post.imageFile?.url {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async { self?.postImageView.image = image }
            }.resume()
        }

        queryComments()
    }

    private func queryComments() {
        guard let postId = post.objectId else { return }

        let postPointer = Pointer<Post>(objectId: postId)

        let query = Comment.query()
            .include("user")
            .order([.ascending("createdAt")])
            .where("post" == postPointer)

        query.find { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self?.comments = comments
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func onSendTapped(_ sender: UIButton) {
        guard let text = commentTextField.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        guard let currentUser = User.current,
              let userId = currentUser.objectId,
              let postId = post.objectId else {
            showAlert(description: "Missing user or post info.")
            return
        }

        var comment = Comment()
        comment.text = text
        comment.authorUsername = currentUser.username
        comment.user = Pointer<User>(objectId: userId)
        comment.post = Pointer<Post>(objectId: postId)

        comment.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.commentTextField.text = ""
                    self?.queryComments()
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "CommentCell")

        let c = comments[indexPath.row]
        cell.textLabel?.text = c.authorUsername ?? "unknown"
        cell.detailTextLabel?.text = c.text ?? ""
        return cell
    }
}
