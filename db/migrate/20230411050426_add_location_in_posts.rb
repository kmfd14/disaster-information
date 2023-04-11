class AddLocationInPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :country, :string
    add_column :posts, :country_code, :string
    add_column :posts, :isp, :string
  end
end
