class Hahahahaha < ActiveRecord::Migration[6.0]
  def change
    rename_column :short_urls, :count_count, :click_count
  end
end
