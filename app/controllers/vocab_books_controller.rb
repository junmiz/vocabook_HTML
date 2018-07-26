class VocabBooksController < ApplicationController
  before_action :set_vocab_book, only: [:show, :edit, :update, :destroy]

  # GET /vocab_books
  # GET /vocab_books.json
  def index
    @vocab_books = VocabBook.all
  end

  # GET /vocab_books/1
  # GET /vocab_books/1.json
  def show
  end

  # GET /vocab_books/new
  def new
    @vocab_book = VocabBook.new
  end

  # GET /vocab_books/1/edit
  def edit
  end

  # POST /vocab_books
  # POST /vocab_books.json
  def create
    @vocab_book = VocabBook.new(vocab_book_params)

    respond_to do |format|
      if @vocab_book.save
        format.html { redirect_to @vocab_book, notice: 'Vocab book was successfully created.' }
        format.json { render :show, status: :created, location: @vocab_book }
      else
        format.html { render :new }
        format.json { render json: @vocab_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vocab_books/1
  # PATCH/PUT /vocab_books/1.json
  def update
    respond_to do |format|
      if @vocab_book.update(vocab_book_params)
        format.html { redirect_to @vocab_book, notice: 'Vocab book was successfully updated.' }
        format.json { render :show, status: :ok, location: @vocab_book }
      else
        format.html { render :edit }
        format.json { render json: @vocab_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vocab_books/1
  # DELETE /vocab_books/1.json
  def destroy
    @vocab_book.destroy
    respond_to do |format|
      format.html { redirect_to vocab_books_url, notice: 'Vocab book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vocab_book
      @vocab_book = VocabBook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vocab_book_params
      params.require(:vocab_book).permit(:word, :comment)
    end
end
