class CreateLastLearnings < ActiveRecord::Migration[5.2]
  def change
    create_table :last_learnings do |t|
      t.integer :user_id
      t.integer :vocab_book_id

      t.timestamps
    end
  end
end
