# TODO: Copy data to User and delete model
class Profile < ActiveRecord::Base
  belongs_to :user
  validates :description, length: { maximum: 500,
    too_long: "%{count} characters is the maximum allowed for descriptions." }, 
    obscenity: true
  validates :neoname, length: { maximum: 20,
    too_long: "%{count} characters is the maximum allowed for Neopets Usernames." }, 
    obscenity: true
end