class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :merchant, index: true
      t.string :description
      t.decimal :price

      t.timestamps
    end
  end
end
