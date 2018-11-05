class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :checkin_is_before_checkout, :check_if_guest_host_do_not_equal,
  :check_listing_avaliability_before_reservation

  def checkin_is_before_checkout
    if (!checkin.nil? && !checkout.nil?) && checkin >= checkout
      errors.add(:checkin, "can't be after checkout")
    end
  end

  def check_if_guest_host_do_not_equal
    if (!self.listing.host.nil? && !self.guest.nil?)
      if self.listing.host.id == self.guest.id
        errors.add(:guest, "can't create reservation on your own listing")
      end
    end
  end

  def check_listing_avaliability_before_reservation
    if (!checkin.nil? && !checkout.nil?)
      self.listing.reservations.each do |r|
        if (checkin <= r.checkout) && (checkout >= r.checkin)
          errors.add(:checkin, "listing is not available")
        end
      end
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    duration * self.listing.price
  end
end
