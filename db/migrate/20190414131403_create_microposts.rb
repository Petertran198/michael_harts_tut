class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
      #added an index on the user_id and created_at columns, because we expect to retrieve all the microposts associated with a given user id in reverse order of creation

     add_index :microposts, [:user_id, :created_at]

  end
end
