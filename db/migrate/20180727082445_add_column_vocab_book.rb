class AddColumnVocabBook < ActiveRecord::Migration[5.2]
  def change
    add_column :vocab_books, :status, :integer
  end
end
