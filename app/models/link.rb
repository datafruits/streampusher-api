class Link < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :url

  #def glyph
  #end
  ##When implementing the glyph class, uncomment the rspec expect.
end
