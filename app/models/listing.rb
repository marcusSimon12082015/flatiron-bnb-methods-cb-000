class Listing < ActiveRecord::Base
  after_create :change_user_to_host
  after_destroy :change_host_to_user

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  def average_review_rating
    reviews.average(:rating)
  end

  def reviews
    @reviews = []
    self.reservations.each do |r|
      if !r.review.nil?
        @reviews << r.review
      end
    end
    return @reviews
  end

  private
  def change_user_to_host
    @user = User.find(self.host.id)
    @user.host = true
    @user.save
  end

  def change_host_to_user
    @user = User.find(self.host.id)
    if @user.listings.empty?
      @user.host = false
      @user.save
    end
  end
end
