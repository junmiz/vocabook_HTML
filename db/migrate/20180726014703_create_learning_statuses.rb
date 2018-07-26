class CreateLearningStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :learning_statuses do |t|
      t.integer :user_id
      t.integer :vocab_book_id
      t.integer :status

      t.timestamps
    end
  end
end
