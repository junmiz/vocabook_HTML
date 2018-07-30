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
  
  # GET /vocabook
  def show_vocabook
    # params[:show_id]→first：最初から／last：続きから／next：次の単語
    # params[:id]→next時のみ現idを渡す
    # 表示する単語帳idは、first：最小id／last：前回終了時単語id以降の最小id／next：現id以降の最小id
    if params[:show_id] == "first"
      get_show_vocabook
    elsif params[:show_id] == "last"
      get_show_vocabook
    elsif params[:show_id] == "next"
      get_show_vocabook
    end
  end
  
  # PATCH/PUT /vocabook/1
  # params[:status]→0：未実施／1：習得／2：復習
  def update_status
    puts "★★★update_status"

    # 単語習得状況の更新
    @learnigStatus = LearningStatus.find_or_create_by(user_id: current_user, vocab_book_id: @vocab_book.id)
    @learnigStatus.user_id = current_user.id
    @learnigStatus.status = params[:status]
    if @learnigStatus.save
    else
    end
    
    # 前回終了単語の更新
    @lastLearning = LastLearning.find_or_create_by(user_id: current_user)
    @lastLEarning.user_id = current_user.id
    @lastLearning.vocab_book_id = @vocab_book.id
    if @lastLEarning.save
    else
    end

    #show_vocabookを[:show_id]="next"で呼び出す
    redirect_to action: show_vocabook, start_id: "next", id: @vocab_book.id
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
    
    def get_show_vocabook
      if params[:show_id] == "first"
        @vocab_book = VocabBook.first
      elsif params[:show_id] == "last"
        @last_learning = current_uuser.last_learnig
        @vocab_book = current_user.VocabBook.where('id > ?', @last_learning.vocab_book_id).first
      elsif params[:show_id] == "next"
        @vocab_book = VocabBook.where('id > ?', params[:id]).first
      end
    end
end
