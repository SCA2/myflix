module ApplicationHelper

  def test_environment
    redirect_to :root if Rails.env.production?
  end

end
