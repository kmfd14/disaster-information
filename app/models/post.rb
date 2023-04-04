class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :address, presence: true

  has_many :comments, dependent: :restrict_with_error
  has_many :post_category_ships
  has_many :categories, through: :post_category_ships

  belongs_to :user
  mount_uploader :image, ImageUploader

  before_create :generate_short_url

  def generate_short_url
    self.short_url = loop do
      random_token = "#{rand(0..9)}#{rand(0..9)}#{rand(0..9)}#{rand(0..9)}"
      break random_token unless Post.exists?(short_url: random_token)
    end
  end

  # def generate_short_url
  #   self.short_url = loop do
  #     random_token = SecureRandom.random_number(10_000).to_s.rjust(4, '0')
  #     break random_token unless Post.exists?(short_url: random_token)
  #   end
  # end

  
end