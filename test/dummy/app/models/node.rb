class Node < ActiveRecord::Base
  
  validates :title, :body, presence: true
  
  def to_label
    title
  end

end