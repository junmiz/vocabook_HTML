require "application_system_test_case"

class VocabBooksTest < ApplicationSystemTestCase
  setup do
    @vocab_book = vocab_books(:one)
  end

  test "visiting the index" do
    visit vocab_books_url
    assert_selector "h1", text: "Vocab Books"
  end

  test "creating a Vocab book" do
    visit vocab_books_url
    click_on "New Vocab Book"

    fill_in "Comment", with: @vocab_book.comment
    fill_in "Word", with: @vocab_book.word
    click_on "Create Vocab book"

    assert_text "Vocab book was successfully created"
    click_on "Back"
  end

  test "updating a Vocab book" do
    visit vocab_books_url
    click_on "Edit", match: :first

    fill_in "Comment", with: @vocab_book.comment
    fill_in "Word", with: @vocab_book.word
    click_on "Update Vocab book"

    assert_text "Vocab book was successfully updated"
    click_on "Back"
  end

  test "destroying a Vocab book" do
    visit vocab_books_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vocab book was successfully destroyed"
  end
end
