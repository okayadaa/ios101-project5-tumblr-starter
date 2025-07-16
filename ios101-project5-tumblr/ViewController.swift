//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import NukeExtensions

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
@IBOutlet weak var tableView: UITableView!
var posts: [Post] = []
let refreshCtrl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tumblrFeedCell", for: indexPath) as? tumblrFeedCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        
        cell.captionLabel?.text = post.summary
        
        if let photo = post.photos.first{
            NukeExtensions.loadImage(with: photo.originalSize.url, into: cell.posterFeedImageView)
        }
        return cell
    }
        

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        refreshCtrl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        tableView.refreshControl = refreshCtrl
        fetchPosts()
    }

    @objc func refreshPosts() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { 
                self.fetchPosts()
            }
        }

    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=BROrZrZhgP9t1SPXcJCzILUBEm5MzVvVSAcYY3qqFrHfVsMx55")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                DispatchQueue.main.async { self.refreshCtrl.endRefreshing() }
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                DispatchQueue.main.async { self.refreshCtrl.endRefreshing() }
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                DispatchQueue.main.async { self.refreshCtrl.endRefreshing() }
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in self?.posts = blog.response.posts
                    self?.tableView.reloadData()
                    self?.refreshCtrl.endRefreshing()
                    let posts = blog.response.posts
                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
                DispatchQueue.main.async { self.refreshCtrl.endRefreshing() }
            }
        }
        session.resume()
    }
}
