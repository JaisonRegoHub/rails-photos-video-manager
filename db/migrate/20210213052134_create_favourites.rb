class CreateFavourites < ActiveRecord::Migration[5.2]
  def change
    create_table :favourites do |t|
      t.belongs_to :user
      t.belongs_to :file_attachment
      t.timestamps
    end
  end
end
