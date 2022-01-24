class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.belongs_to :source, index: true, foreign_key: true
      t.string :code, unique: true, null: false
      t.string :name


      t.timestamps
    end
    add_index :events, [:code], :unique => true
  end
end
