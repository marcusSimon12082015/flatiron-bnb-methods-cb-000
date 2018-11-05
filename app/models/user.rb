class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def host_reviews
    @host_reviews = []
    self.listings.each do |l|
      l.reservations.each do |r|
          @host_reviews << r.review
      end
    end
    return @host_reviews
  end

  def guests
    @guests = []
    self.listings.each do |l|
      l.reservations.each do |r|
        @guests << r.guest
      end
    end
    return @guests
  end

  def hosts
    @hosts = []
    self.trips.each do |t|
      @hosts << t.listing.host
    end
    return @hosts
  end
end
