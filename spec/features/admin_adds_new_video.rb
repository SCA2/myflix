require 'spec_helper'

feature 'admin adds new video' do
  scenario 'admin enters valid data to create new video' do
    dramas = Fabricate(:category, name: 'Dramas')
    sign_in_admin
    visit new_admin_video_path

    fill_in 'Title', with: 'Monk'
    select 'Dramas', from: 'Category'
    fill_in 'Description', with: 'Neurotic detective solves crimes'
    attach_file 'Large cover', 'spec/support/uploads/monk_large.jpg'
    attach_file 'Small cover', 'spec/support/uploads/monk.jpg'
    fill_in 'Video URL', with: 'http://www.example.com/my_video.mp4'
    click_button 'Add Video'

    sign_out_user
    sign_in_user

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']")

  end
end