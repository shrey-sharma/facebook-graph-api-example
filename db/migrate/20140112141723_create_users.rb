class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :fid
      t.string :username
      t.string :name
      t.string :gender
      t.text :hometown
      t.text :location
      t.text :bio
			t.string :access_token

      t.timestamps
    end
  end
end
