class Node < ActiveRecord::Base

  validates :title, :body, presence: true

  attr_accessor :online

  def to_label
    title
  end

  def online?
    online.nil? || online
  end

end