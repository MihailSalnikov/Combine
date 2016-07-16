class User < ActiveRecord::Base
  validates :time, presence: true
end
