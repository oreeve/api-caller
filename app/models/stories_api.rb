require 'faraday'
require 'json'

class StoriesApi

  def initialize
  end

  def call
    while true do
      begin
        save_stories
        sleep 60
      rescue Faraday::ConnectionFailed
        retry
      end
    end
  end

  def save_stories
    Rails.logger.info("Stories API called at #{Time.now}")
    data = get_new_stories
    stories = data["stories"]
    stories.each do |story|
      unless SavedStory.find_by(story_id:story["id"]).present?
        saved_story = SavedStory.create(
          story_id: story["id"],
          author: story["user_id"],
          headline: story["headline"],
          embargoed: story["published_at"].include?("00.000"),
          story_created: story["created_at"],
          story_updated: story["updated_at"],
          story_published: story["published_at"],
        )
        saved_story.save!
      end
    end
  end

  def get_new_stories
    base_url = "https://www.informagm.com/"
    time = Time.now.utc-2.minutes
    path = "/api/v1/feeds/stories?updated_at=#{time.strftime("%FT%T")+"%2B00%3A00"}&per=50"

    conn = Faraday.new(url: base_url) do |faraday|
      faraday.headers[:Accept] = 'application/json'
      faraday.headers[:Authorization] = "Token token=903890bfe6f5dcbb231e472c0ee33ed7, company_key=61047dce-b69a-4de1-986e-e6db9d46ef97"
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter :net_http
    end

    response = conn.get(path)
    JSON.parse(response.body)
  end

  def get_all_stories
    base_url = "https://www.informagm.com/"
    time = "2016-06-09T14%3A52%3A41%2B00%3A00&per=150"
    per = SavedStory.all.count
    # path = "/api/v1/feeds/stories?per=#{per}"
    path = "/api/v1/feeds/stories?updated_at=#{time}"

    conn = Faraday.new(url: base_url) do |faraday|
      faraday.headers[:Accept] = 'application/json'
      faraday.headers[:Authorization] = "Token token=903890bfe6f5dcbb231e472c0ee33ed7, company_key=61047dce-b69a-4de1-986e-e6db9d46ef97"
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter :net_http
    end

    response = conn.get(path)
    data = JSON.parse(response.body)
    stories = data["stories"]
    # binding.pry
    all_ids = []
    stories.each { |story| all_ids << story["id"] }
    return all_ids
  end

  def compare_stories
    saved = SavedStory.all.map(&:story_id)
    all = get_all_stories
    # binding.pry
    puts saved.count.to_s + " saved and " + all.count.to_s + " total. Same IDs?"
    saved.sort == all.sort
  end

### Development Methods

  def get_new_dev_stories
    base_url = "http://localhost:3000/"
    time = Time.now.utc-2.minutes
    path = "/api/v1/feeds/stories?updated_at=#{time.strftime("%FT%T")+"%2B00%3A00"}&per=50"

    conn = Faraday.new(url: base_url) do |faraday|
      faraday.headers[:Accept] = 'application/json'
      faraday.headers[:Authorization] = "Token token=903890bfe6f5dcbb231e472c0ee33ed7, company_key=61047dce-b69a-4de1-986e-e6db9d46ef97"
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter :net_http
    end

    response = conn.get(path)
    JSON.parse(response.body)
  end

  def save_dev_stories
    Rails.logger.info("Stories API called at #{Time.now}")
    data = get_new_dev_stories
    stories = data["stories"]
    stories.each do |story|
      unless SavedStory.find_by(story_id:story["id"]).present?
        saved_story = SavedStory.create(
          story_id: story["id"],
          author: story["user_id"],
          headline: story["headline"],
          embargoed: story["published_at"].include?("00.000"),
          story_created: story["created_at"],
          story_updated: story["updated_at"],
          story_published: story["published_at"],
        )
        saved_story.save!
      end
    end
  end

  def get_all_dev_stories
    base_url = "http://localhost:3000/"
    time = "2016-06-09T18%3A01%3A50%2B00%3A00&per=150"
    per = SavedStory.all.count
    # path = "/api/v1/feeds/stories?per=#{per}"
    path = "/api/v1/feeds/stories?updated_at=#{time}"

    conn = Faraday.new(url: base_url) do |faraday|
      faraday.headers[:Accept] = 'application/json'
      faraday.headers[:Authorization] = "Token token=903890bfe6f5dcbb231e472c0ee33ed7, company_key=61047dce-b69a-4de1-986e-e6db9d46ef97"
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter :net_http
    end

    response = conn.get(path)
    data = JSON.parse(response.body)
    stories = data["stories"]
    # binding.pry
    all_ids = []
    stories.each { |story| all_ids << story["id"] }
    return all_ids
  end

  def call_dev
    while true do
      begin
        save_dev_stories
        sleep 60
      rescue Faraday::ConnectionFailed
        retry
      end
    end
  end

  def compare_dev_stories
    saved = SavedStory.all.map(&:story_id)
    all = get_all_dev_stories
    # binding.pry
    puts saved.count.to_s + " saved and " + all.count.to_s + " total. Same IDs?"
    saved.sort == all.sort
  end

end
