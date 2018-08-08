class ProblemsController < ApplicationController
  before_action :destroy_all, only: [:start]

  def show
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
    
    redirect_to problem_url(id: 0)
  end

  def answer
  end

  private
    def destroy_all
      #Problem.where(user_id: current_user.id).destroy_all
      User.find(current_user.id).problems.destroy_all
    end
end
