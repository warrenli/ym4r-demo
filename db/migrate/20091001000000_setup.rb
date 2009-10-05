class Setup < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string      :name
      t.float       :latitude
      t.float       :longitude
      t.timestamps
    end
    create_table :locations do |t|
      t.integer     :city_id
      t.string      :name
      t.string      :street
      t.float       :latitude
      t.float       :longitude
      t.timestamps
    end
    add_index(:locations, :city_id, :unique => false)
  end
  
  def self.down
    drop_table :cities
    drop_table :locations
  end
end
