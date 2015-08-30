require 'spec_helper'


feature 'user interacts with the queue' do
  
  scenario 'user adds videos to and reorders queue' do

    videos = []
    category  = Fabricate(:category)
    videos[0] = Fabricate(:video, category: category)
    videos[1] = Fabricate(:video, category: category)
    videos[2] = Fabricate(:video, category: category)

    sign_in_user

    add_videos_to_queue(videos)
    reorder_queue(videos)
    update_queue
    verify_queue(videos)

  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def add_videos_to_queue(videos)
    videos.each do |video|
      add_video_to_queue(video)
      verify_hidden_button(video)
    end
  end

  def add_video_to_queue(video)
    expect(page.current_path).to eq "/home"
    click_video_on_home_page(video)
    expect(page.current_path).to eq "/videos/#{video.id}"
    click_link "+ My Queue"
    expect(page.current_path).to eq "/queue_items"
    expect(page).to have_content "#{video.title}"
  end
  
  def verify_hidden_button(video)
    click_video_on_home_page(video)
    expect(page.current_path).to eq "/videos/#{video.id}"
    expect(page).to have_no_content "+ My Queue"
    find("a[href='/home']").click
  end

  def reorder_queue(videos)
    find("a[href='/my_queue']").click
    expect(page.current_path).to eq "/my_queue"
    inputs = page.all("input#queue_items__order")
    
    inputs[0].set 2
    inputs[1].set 3 
    inputs[2].set 1
  end

  def verify_queue(videos)
    inputs = page.all("input#queue_items__order")
    within("section.my_queue") do
      queue = page.all("a[href^='/videos/']")
      expect(queue[0].text).to eq videos[2].title
      expect(queue[1].text).to eq videos[0].title
      expect(queue[2].text).to eq videos[1].title
    end
  end

end

