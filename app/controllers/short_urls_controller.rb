class ShortUrlsController < ApplicationController
  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    urls = ShortUrl.all.limit(100).order(click_count: :desc)
    render json: { urls: public_attributes(urls) }
  end

  def create
    url = ShortUrl.find_by(full_url: params[:full_url])

    if url.nil?
      url = ShortUrl.new(short_url_params)

      if url.save
        render json: { title: url.title, full_url: url.full_url, short_code: url.short_code, click_count: url.click_count }
      else
        render json: { errors: url.errors.full_messages }
      end
    end
  end

  def show
    url = ShortUrl.find_by(short_code: params[:id])

    if url
      url.increment!(:click_count)
      redirect_to url.full_url, format: :json
    else
      render json: { error: 'Url not found' }, status: :not_found
    end
  end

  private

  def short_url_params
    params.permit(:full_url)
  end

  def public_attributes(urls)
    urls.each_with_object([]) do |url, arr|
      arr << { title: url.title, full_url: url.full_url, short_code: url.short_code, click_count: url.click_count }
    end
  end
end
