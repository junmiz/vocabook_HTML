class VocabookController < ApplicationController
  before_action :set_vocab_book, only: [:update]
  before_action :set_learning_status, only: [:update]
  before_action :set_last_learning, only: [:update]

  def show
    if params[:show_id] == "first"
      @vocab_book = VocabBook.first
    elsif params[:show_id] == "last"
      @last_learning = current_uuser.last_learnig
      @vocab_book = current_user.VocabBook.where('id > ?', @last_learning.vocab_book_id).first
    elsif params[:show_id] == "next"
      @vocab_book = VocabBook.where('id > ?', params[:id]).first
      if @vocab_book.nil?
        @vocab_book = VocabBook.first
      end
    end
  end

  def update
    # 単語習得状況の更新
    @learning_status.user_id = current_user.id
    @learning_status.status = params[:status]
    if @learning_status.save
    else
       puts "★★★error:lalearnigStatus"
    end
    
    # 前回終了単語の更新
    @last_learning.user_id = current_user.id
    @last_learning.vocab_book_id = @vocab_book.id
    if @last_learning.save
    else
      puts "★★★error:last_learning.save"
    end

    #show_vocabookを[:show_id]="next"で呼び出す
    redirect_to action: :show, show_id: "next", id: @vocab_book.id
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vocab_book
      @vocab_book = VocabBook.find(params[:id])
    end
    
    def set_learning_status
      @learning_status = LearningStatus.find_or_create_by(user_id: current_user.id, vocab_book_id: @vocab_book.id)
    end
    
    def set_last_learning
      @last_learning = LastLearning.find_or_create_by(user_id: current_user.id)
    end
end
