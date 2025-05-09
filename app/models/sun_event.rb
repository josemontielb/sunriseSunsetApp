class SunEvent < ApplicationRecord
    validates :location, :date, :sunrise_time, :sunset_time, presence: true
  end
  