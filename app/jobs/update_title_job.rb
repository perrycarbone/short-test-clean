class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)
    short_url = ShortUrl.find(short_url_id)
    agent = Mechanize.new
    agent.follow_meta_refresh = true
    page = agent.get(short_url.full_url)
    short_url.update!(title: page.title)
  end
end
