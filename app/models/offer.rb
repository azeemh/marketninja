class Offer < ApplicationRecord
  belongs_to :categorizable, :polymorphic => true, optional: true
end
