//
//  PostCell.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private var imageTask: URLSessionDataTask?

    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        imageTask?.cancel()
        imageTask = nil
    }

    func configure(with post: Post) {
        usernameLabel.text = post.user?.username ?? "unknown"
        captionLabel.text = post.caption ?? ""

        if let date = post.createdAt {
            dateLabel.text = DateFormatter.postFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }

        guard let url = post.imageFile?.url else { return }

        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.postImageView.image = image
            }
        }
        imageTask?.resume()
    }
}
