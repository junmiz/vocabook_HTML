class CreateCohiceQuestionStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :cohice_question_statuses do |t|
      t.integer :user_id
      t.integer :vocab_book_id
      t.integer :status

      t.timestamps
    end
  end
end
