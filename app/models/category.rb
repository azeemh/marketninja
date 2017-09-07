class Category < ApplicationRecord
  has_many :offers, :as => :categorizable
  has_many :suppliers, :as => :categorizable
end
