class AddShortUrlToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :short_url, :string
  end
end
