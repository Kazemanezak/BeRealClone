//
//  PostCell.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import UIKit
import Foundation

class PostCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    

    private var imageTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Ensure blur effect is actually applied
        blurView.effect = UIBlurEffect(style: .regular)
        blurView.isUserInteractionEnabled = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        imageTask?.cancel()
        imageTask = nil

        blurView.isHidden = true   // default; configure() will set it correctly
    }

    func configure(with post: Post) {
        // Username
        usernameLabel.text = post.user?.username ?? post.authorUsername ?? "unknown"
        
        blurView.isHidden = false

        // Caption
        captionLabel.text = post.caption ?? ""

        // Date/time to display (prefer photoTakenAt, fallback to createdAt)
        let displayDate = post.photoTakenAt ?? post.createdAt

        var dateText = ""
        if let d = displayDate {
            dateText = DateFormatter.postFormatter.string(from: d)
        }

        // Location to display (coords)
        if let lat = post.latitude, let lon = post.longitude {
            dateText += " • \(String(format: "%.4f", lat)), \(String(format: "%.4f", lon))"
        }

        dateLabel.text = dateText

        // Image
        if let url = post.imageFile?.url {
            imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.postImageView.image = image
                }
            }
            imageTask?.resume()
        }
        
        

        // ===== BLUR LOGIC (Step 4/5) =====
        if let currentUser = User.current,
           let lastPostedDate = currentUser.lastPostedDate,
           let postCreatedDate = post.createdAt,
           let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {

            // Unblur if within 24 hours of the user's last post
            blurView.isHidden = abs(diffHours) < 24
        } else {
            // If user never posted (or dates missing), blur by default
            blurView.isHidden = false
        }
    }
}
