require 'spec_helper'

feature 'User follows another user' do

  let(:user_2)    { Fabricate(:user) }
  let(:category)  { Fabricate(:category) }
  let!(:video)    { category.videos.first }

  scenario "user follows and un-follows someone" do

    Fabricate(:review, video: video, user: user_2)
    sign_in_user
    click_video_on_home_page(video)
    click_link user_2.name
    click_link "Follow"
    expect(page.current_path).to eq "/people"
    expect(page).to have_content "Following #{user_2.name}"
    unfollow(user_2)
    expect(page).to have_content "No longer following #{user_2.name}"

  end

  def unfollow(user)
    tr = find('a', text: user.name).find(:xpath, '..').find(:xpath, '..')
    within(tr) do
      find("a[data-method= 'delete']").click
    end
  end
end