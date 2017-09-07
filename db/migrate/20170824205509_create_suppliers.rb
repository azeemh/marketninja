class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :platform
      t.string :link
      t.references :category, foreign_key: true
      t.references :categorizable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
