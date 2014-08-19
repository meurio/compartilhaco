class Campaign < ActiveRecord::Base
  has_many :campaign_spreaders
  mount_uploader :image, ImageUploader

  def share
    campaign_spreaders.each {|cs| cs.share}
    update_attribute :shared_at, Time.now
  end
end
