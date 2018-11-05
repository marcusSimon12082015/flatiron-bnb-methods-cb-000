class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  validates :name, presence: true

  def neighborhood_openings(date1,date2)
    @dateStart = Date.parse date1
    @dateEnd = Date.parse date2
    @array_of_listings = []
    self.listings.each do |l|
      @isReady = true
      l.reservations.each do |r|
        @rStart = r.checkin
        @rEnd = r.checkout
        if (@dateStart <= @rEnd) && (@dateEnd >= @rStart)
          @isReady = false
        end
      end
      if @isReady
        @array_of_listings << l
      end
    end
    @array_of_listings
  end

  def self.highest_ratio_res_to_listings
    @higest_ratio = 0.00
    @neighborhoods = self.all
    @neighborhood = nil
    @neighborhoods.each do |n|
      n.listings.each do |l|
        @current_ratio = l.reservations.count / n.listings.count
        if @higest_ratio < @current_ratio
          @higest_ratio = @current_ratio
          @neighborhood = n
        end
      end
    end
    return @neighborhood
  end

  def self.most_res
    @neighborhoods = self.all
    @neighborhood = nil
    @max = 0
    @neighborhoods.each do |n|
      n.listings.each do |l|
        if @max < l.reservations.count
          @max = l.reservations.count
          @neighborhood = n
        end
      end
    end
    return @neighborhood
  end
end
