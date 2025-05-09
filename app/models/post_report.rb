class PostReport < Struct.new(:word_count, :word_histogram)
  def self.generate(post)
    PostReport.new(
      post.content.split.map { |word| word.gsub(/\w/, "") }.count,
      calc_histogram(post)
    )
  end

  private

  def self.calc_histogram(post)
    (post
      .content
      .split
      .map { |word| word.gsub(/\w/, "") }
      .map(&:downcase)
      .group_by { |word| word }
      .transform_values(&:size))
  end
end
