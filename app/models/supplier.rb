class Supplier < ApplicationRecord
  #belongs_to :category
  belongs_to :categorizable, :polymorphic => true, optional: true
end
