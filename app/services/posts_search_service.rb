class PostsSearchService
  def self.search(curr_posts, query)
    curr_posts.where("title LIKE ?", "%#{query}%")
  end
end
