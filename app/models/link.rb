class Link < ApplicationRecord
  belongs_to :user
  validates :long_link, presence: true
  validates :shortened_link, uniqueness: true, presence: true
  validate :long_link_has_valid_format
  validates_presence_of :click_count
  validates_presence_of :user_id

  before_create :set_shortened_link

  def belongs_to?(user)
    user_id == user.id
  end

  def raise_click_count
    update(click_count: click_count + 1)
  end

  private
  def set_shortened_link
    self.shortened_link = "#{ENV['DOMAIN']}/?l=#{SecureRandom.alphanumeric}"
  end

  def long_link_has_valid_format
    return if long_link.blank?
    return if long_link.match(/^(?:(https?:\/\/(www\.)?)|((https?:\/\/)?(www\.)))(?!(w{1,2}\.))([-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,6}\b)*(\/[\/\d\w.-]*)*(?:\?)*(.+)*/)

    errors.add(:long_link, I18n.t('errors.link.url.url_has_invalid_format'))
  end
end
