class AddColumnsToShortUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :short_urls, :full_url, :string
    add_column :short_urls, :short_code, :string
    add_column :short_urls, :click_counter, :integer
    add_column :short_urls, :title, :string
  end
end
