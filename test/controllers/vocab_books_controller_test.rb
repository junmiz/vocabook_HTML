require 'test_helper'

class VocabBooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vocab_book = vocab_books(:one)
  end

  test "should get index" do
    get vocab_books_url
    assert_response :success
  end

  test "should get new" do
    get new_vocab_book_url
    assert_response :success
  end

  test "should create vocab_book" do
    assert_difference('VocabBook.count') do
      post vocab_books_url, params: { vocab_book: { comment: @vocab_book.comment, word: @vocab_book.word } }
    end

    assert_redirected_to vocab_book_url(VocabBook.last)
  end

  test "should show vocab_book" do
    get vocab_book_url(@vocab_book)
    assert_response :success
  end

  test "should get edit" do
    get edit_vocab_book_url(@vocab_book)
    assert_response :success
  end

  test "should update vocab_book" do
    patch vocab_book_url(@vocab_book), params: { vocab_book: { comment: @vocab_book.comment, word: @vocab_book.word } }
    assert_redirected_to vocab_book_url(@vocab_book)
  end

  test "should destroy vocab_book" do
    assert_difference('VocabBook.count', -1) do
      delete vocab_book_url(@vocab_book)
    end

    assert_redirected_to vocab_books_url
  end
end
