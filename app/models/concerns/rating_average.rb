module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    a = ratings.map { |rating| rating.score }
    b = a.inject(0) { |result, element| result + element }
    b.to_f/ratings.count
  end

end