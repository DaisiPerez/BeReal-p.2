import UIKit
import ParseSwift

class CommentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    var post: Post!
    private var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comments"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Load comments
        loadComments()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Load Comments
    func loadComments() {
        guard let postId = post.objectId else { return }
        
        let query = Comment.query()
            .where("post" == post)
            .order([.descending("createdAt")])
            .include("user")
        
        query.find { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self?.comments = comments
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("❌ Error loading comments: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Post Comment
    @IBAction func postCommentTapped(_ sender: UIButton) {
        guard let commentText = commentTextField.text, !commentText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        guard let currentUser = User.current else {
            showAlert(description: "You must be logged in to comment")
            return
        }
        
        var comment = Comment()
        comment.text = commentText
        comment.user = currentUser
        comment.post = post
        comment.username = currentUser.username
        comment.name = currentUser.name ?? currentUser.username
        
        comment.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let savedComment):
                    print("✅ Comment saved!")
                    
                    // Update comment count on post
                    if var post = self?.post {
                        let currentCount = post.commentCount ?? 0
                        post.commentCount = currentCount + 1
                        
                        post.save { result in
                            switch result {
                            case .success:
                                print("✅ Comment count updated")
                            case .failure(let error):
                                print("❌ Error updating count: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    // Add comment to list and reload
                    self?.comments.insert(savedComment, at: 0)
                    self?.tableView.reloadData()
                    self?.commentTextField.text = ""
                    self?.commentTextField.resignFirstResponder()
                    
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Keyboard Handling
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            view.frame.origin.y = -keyboardHeight + 100
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: - TableView DataSource & Delegate
extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        let comment = comments[indexPath.row]
        
        // Configure cell
        var config = cell.defaultContentConfiguration()
        
        let username = comment.username ?? "Unknown"
        let name = comment.name ?? username
        let text = comment.text ?? ""
        
        config.text = "\(name) (@\(username))"
        config.secondaryText = text
        config.textProperties.font = .boldSystemFont(ofSize: 14)
        config.secondaryTextProperties.font = .systemFont(ofSize: 14)
        config.secondaryTextProperties.numberOfLines = 0
        
        cell.contentConfiguration = config
        return cell
    }
}
