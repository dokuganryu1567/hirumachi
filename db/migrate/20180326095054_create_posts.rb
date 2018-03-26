class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.string :shop_name
      t.integer :congestion
      t.string :image
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
