module ApplicationHelper
  def review_options(selected=nil)
    options_for_select((1..5).map {|n| [pluralize(n, "star"), n]}, selected)
  end

  def average_ratings
    (10..50).map { |num| num / 10.0 }
  end
end
