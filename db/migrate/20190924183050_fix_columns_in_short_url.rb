class FixColumnsInShortUrl < ActiveRecord::Migration[6.0]
  def change
    remove_column :short_urls, :click_counter
    add_column :short_urls, :count_count, :integer, default: 0
  end
end
