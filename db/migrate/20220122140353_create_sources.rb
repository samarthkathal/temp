class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.string :code, unique: true, null: false
      t.string :name


      t.timestamps
    end
    add_index :sources, [:code], :unique => true
  end
end
