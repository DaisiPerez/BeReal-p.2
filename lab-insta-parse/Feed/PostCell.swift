import UIKit
import Alamofire
import AlamofireImage

class PostCell: UITableViewCell {

    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    
    // New outlets - Add these to your storyboard (OPTIONAL until connected)
    @IBOutlet weak var locationLabel: UILabel?
    @IBOutlet weak var commentButton: UIButton?
    @IBOutlet weak var commentCountLabel: UILabel?

    private var imageDataRequest: DataRequest?
    private var currentPost: Post?
    
    // Callback for comment button tap
    var onCommentTapped: ((Post) -> Void)?

    func configure(with post: Post) {
        currentPost = post
        
        // Blur logic
        if let currentUser = User.current,
           let lastPostedDate = currentUser.lastPostedDate,
           let postCreatedDate = post.createdAt,
           let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {
            blurView.isHidden = abs(diffHours) < 24
        } else {
            blurView.isHidden = false
        }
        
        // Username
        if let user = post.user {
            usernameLabel.text = user.username
        }

        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }

        // Caption
        captionLabel.text = post.caption

        // Date
        if let date = post.createdAt {
            dateLabel.text = DateFormatter.postFormatter.string(from: date)
        }
        
        // Location
        configureLocation(with: post)
        
        // Comment count
        let count = post.commentCount ?? 0
        commentCountLabel?.text = count == 1 ? "1 comment" : "\(count) comments"
    }
    
    private func configureLocation(with post: Post) {
        var locationComponents: [String] = []
        
        if let city = post.city {
            locationComponents.append(city)
        }
        if let state = post.state {
            locationComponents.append(state)
        }
        if let country = post.country {
            locationComponents.append(country)
        }
        
        if locationComponents.isEmpty {
            locationLabel?.text = "📍 Location unavailable"
            locationLabel?.textColor = .systemGray
        } else {
            locationLabel?.text = "📍 " + locationComponents.joined(separator: ", ")
            locationLabel?.textColor = .label
        }
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        if let post = currentPost {
            onCommentTapped?(post)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        imageDataRequest?.cancel()
        currentPost = nil
        onCommentTapped = nil
    }
}
