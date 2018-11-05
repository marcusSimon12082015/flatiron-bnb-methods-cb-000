class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :description, presence: true
  validates :rating, presence: true
  validates :guest, presence: true
  validates :reservation, presence: true

  validate :check_if_reservation_is_valid

  def check_if_reservation_is_valid
    if self.reservation.nil?
      errors.add(:self, "There is no associated reservation")
    elsif !self.reservation.status.eql? "accepted"
        errors.add(:self,"reservation is not accepted")
    elsif self.reservation.checkout > Date.today
        errors.add(:self,"Reservation is not yet done")
        #pry
    end
  end
end
