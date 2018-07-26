class CreateVocabBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :vocab_books do |t|
      t.text :word
      t.text :comment

      t.timestamps
    end
  end
end
