class UnfollowRelation < ActiveRecord::Base
  belongs_to :unfollower, class_name: "User"
  belongs_to :unfollowing, class_name: "User"

  validates :unfollower_id, presence: true
  validates :unfollowing_id, presence: true
end
