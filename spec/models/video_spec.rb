require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:category) }

  let!(:category) { Fabricate(:category) }

  it "retrieves videos in title order" do
    c = Video.create(title: 'Title c', description: 'Description c', category: category)
    b = Video.create(title: 'Title b', description: 'Description b', category: category)
    a = Video.create(title: 'Title a', description: 'Description a', category: category)
    expect(Video.all.sorted).to eq [a, b, c]
  end

  describe "search_by_title" do
    it "returns empty array on no match" do
      expect(Video.search_by_title("non-existent title")).to eq []
    end
    
    it "returns one Video for exact match" do
      video = Video.create(title: 'Title', description: 'Description', category: category)
      expect(Video.search_by_title("Title")).to eq [video]
    end

    it "returns array of Videos for partial matches" do
      a = Video.create(title: 'Title a', description: 'Description a', category: category)
      b = Video.create(title: 'Title b', description: 'Description b', category: category)
      c = Video.create(title: 'Title c', description: 'Description c', category: category)
      expect(Video.search_by_title('Title')).to eq [a, b, c]
    end

    it "ignores case" do
      a = Video.create(title: 'Title a', description: 'Description a', category: category)
      b = Video.create(title: 'Title b', description: 'Description b', category: category)
      c = Video.create(title: 'Title c', description: 'Description c', category: category)
      expect(Video.search_by_title('title')).to eq [a, b, c]
    end

    it "returns array of Videos in title order" do
      c = Video.create(title: 'Title c', description: 'Description c', category: category)
      b = Video.create(title: 'Title b', description: 'Description b', category: category)
      a = Video.create(title: 'Title a', description: 'Description a', category: category)
      expect(Video.search_by_title('title')).to eq [a, b, c]
    end

    it "returns empty array for empty search string" do
      c = Video.create(title: 'Title c', description: 'Description c', category: category)
      b = Video.create(title: 'Title b', description: 'Description b', category: category)
      a = Video.create(title: 'Title a', description: 'Description a', category: category)
      expect(Video.search_by_title('')).to eq []
    end
  end

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek", description: "movie")
        star_wars = Fabricate(:video, title: "Star Wars", description: "movie")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end
    
    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to eq [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars1 = Fabricate(:video, title: "Star Wars: Episode I")
        star_wars2 = Fabricate(:video, title: "Star Wars: Episode II")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars1, star_wars2]
      end
    end

    context "with title, description and reviews" do
      it 'returns an an empty array for no match with reviews option' do
        star_wars = Fabricate(:video, title: "Star Wars")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, body: "such a star movie!")
        refresh_index

        expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
      end

      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "the sun is a star!")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, body: "such a star movie!")
        refresh_index

        expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end
  
    context "with average ratings" do
      let(:star_wars_1) { Fabricate(:video, title: "Star Wars 1") }
      let(:star_wars_2) { Fabricate(:video, title: "Star Wars 2") }
      let(:star_wars_3) { Fabricate(:video, title: "Star Wars 3") }

      before do
        Fabricate(:review, rating: "2", video: star_wars_1)
        Fabricate(:review, rating: "4", video: star_wars_1)
        Fabricate(:review, rating: "4", video: star_wars_2)
        Fabricate(:review, rating: "2", video: star_wars_3)
        refresh_index
      end

      context "with only rating_from selected" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "4.1").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "4.0").records.to_a).to eq [star_wars_2]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "3.0").records.to_a).to eq [star_wars_2, star_wars_1]
        end
      end

      context "with only rating_to selected" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_to: "1.5").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_to: "2.5").records.to_a).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_to: "3.4").records.to_a).to eq [star_wars_1, star_wars_3]
        end
      end

      context "with both rating_from and rating_to selected" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "3.4", rating_to: "3.9").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "1.8", rating_to: "2.2").records.to_a).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "2.9", rating_to: "4.1").records.to_a).to eq [star_wars_2, star_wars_1]
        end

        it "returns an empty array when to is lower than from" do
          expect(Video.search("Star Wars", rating_from: "3.0", rating_to: "1.0").records.to_a).to eq []
        end
      end

      it "returns an array of one video by title and an average rating option" do
        expect(Video.search("Star Wars 1", rating_from: "3.0").records.to_a).to eq [star_wars_1]
      end

      it "sorts videos based on returned average ratings in descending order" do
        expect(Video.search("Star Wars", rating_from: "1.0", rating_to: "5.0").records.to_a).to eq [star_wars_2, star_wars_1, star_wars_3]
      end
    end
  end
end