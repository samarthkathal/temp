class CreateFields < ActiveRecord::Migration[7.0]
  def change
    create_table :fields do |t|
      t.belongs_to :event, index: true, foreign_key: true
      t.string :code, unique: true, null: false
      t.string :name
      
      t.timestamps
    end
    add_index :fields, [:code], :unique => true
  end
end
