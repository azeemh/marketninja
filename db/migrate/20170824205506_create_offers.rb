class CreateOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :offers do |t|
      t.string :product_name
      t.string :platform
      t.decimal :virability
      t.date :date_ad_posted
      t.decimal :price
      t.text :product_details
      t.string :link
      t.string :keywords
      t.string :video_link
      t.references :category, foreign_key: true
      t.references :categorizable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
