class ProblemsController < ApplicationController
  before_action :destroy_all, only: [:start]

  def show
    @problem = current_user.problems.find(params[:id])
    @vocab_book = VocabBook.find(@problem.vocab_book_id)
    
    # 不正解の単語を3つ取得
    array = Array.new(4)
    cnt = 0
    loop{
      @vocab_books = VocabBook.order("RANDOM()").limit(3)
      
      flg = false
      @vocab_books.each do |v|
        array[cnt] = v.id
        cnt += 1
        if v.id == @vocab_book.id
          flg = true
        end
      end
      if !flg 
        break
      end
    }
    array[3] = @vocab_book.id
    array = array.shuffle

    @vocab_books = VocabBook.find(array)
  end

  # 試験問題の初期化
  # params[:cnt] 10,20,50:10,20,50問／0：全問／-1：間違えた問題のみ
  def start
    # 試験問題の初期化 before_action
    
    problem_cnt = params[:cnt]
    if params[:cnt].to_i == 0       # 全問
      problem_cnt = VocabBook.cnt
    elsif params[:cnt].to_i == -1   # 間違えた問題のみ
      problem_cnt = ChoiceQuestionStatus.where(user_id: current_user.id).where(status: 2).count
    end
    
    # 単語帳を指定件数ランダムに取得する
    if params[:cnt].to_i >= 0   # 10,20,50問、全問
      vocab_books = VocabBook.order("RANDOM()").limit(problem_cnt)
    else                        # 間違えた問題のみ
      #choice_qestion_statuses = User.find(current_user.id).choice_qestion_statuses.order("RANDOM()").limit(problem_cnt)
      #choice_qestion_statuses.each do |choice_qestion_status|
      #end
    end

    vocab_books.each do |vocab_book|
      problem = Problem.new(user_id: current_user.id, vocab_book_id: vocab_book.id)
      if problem.save
      else
         puts "★★★error:problem.save"
      end
    end
    
    redirect_to problems_url(id: Problem.first.id)
  end

  def answer
  end

  private
    def destroy_all
      #Problem.where(user_id: current_user.id).destroy_all
      User.find(current_user.id).problems.destroy_all
    end
end
