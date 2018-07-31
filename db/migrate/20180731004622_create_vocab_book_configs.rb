class CreateVocabBookConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :vocab_book_configs do |t|
      t.integer :user_id
      t.integer :filter

      t.timestamps
    end
  end
end
