class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns do |t|
      t.belongs_to :event, index: true, foreign_key: true
      t.string :code, unique: true, null: false
      t.string :name
      t.boolean :state, null: false, default: false
      t.jsonb :conditions
      
      t.timestamps
    end
    add_index :campaigns, [:code], :unique => true
  end
end
