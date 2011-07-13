class Entry < ActiveRecord::Base
  validates_presence_of :japanese, :english, :romaji
end
