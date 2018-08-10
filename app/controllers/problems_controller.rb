class ProblemsController < ApplicationController
  before_action :destroy_all, only: [:start]

  def show
    @problem = current_user.problems.find(params[:id])
    @vocab_book = VocabBook.find(@problem.vocab_book_id)
    
    # 不正解の単語を3つ取得
    array = Array.new(4)
    loop{
      @vocab_books = VocabBook.order("RANDOM()").limit(3)
      
      cnt = 0
      flg = false
      @vocab_books.each do |v|
        array[cnt] = v.id
        cnt += 1
        if v.id == @vocab_book.id
          flg = true
        else
          puts '★★★'
          puts v.id
          puts @vocab_book.id
        end
      end
      if !flg 
        break
      end
    }
    array[3] = @vocab_book.id
    array = array.shuffle

    @vocab_books = VocabBook.find(array)
    
    # 何問目＆問題数取得
    @prob_cnt = current_user.problems.count
    @prob_num = current_user.problems.where('id <= ?', params[:id]).count
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
    
    redirect_to problems_url(id: current_user.problems.first)
  end

  def answer
    # 正解/不正解の判定（problem.単語id vs 選択した単語id）
    @problem = Problem.find(params[:prob_id])
    @prob_vocabook = VocabBook.find(@problem.vocab_book_id)
    
    @ans_vocabook = VocabBook.find(params[:ans_id])
    
    # 今回試験結果の保存
    if @prob_vocabook.id == @ans_vocabook.id
      # 正解
      @problem.judgment = 0
    else
      # 不正解
      @problem.judgment = 1
    end
    
    if @problem.save
    else
      puts "★★★error:problem.save"
    end
    
    # 全試験結果の保存
    choice_question_status = ChoiceQuestionStatus.find_or_create_by(user_id: current_user, vocab_book_id: @prob_vocabook)
    choice_question_status.status = @problem.judgment
    if choice_question_status.save
    else
      puts "★★★error:choice_question_status.save"
    end
    
    # 次問題id取得
    @next_problem = current_user.problems.where('id > ?', params[:prob_id]).first
  end
  
  def result
    # 正解率取得
    @prob_cnt = current_user.problems.count
    @corr_num = current_user.problems.where('judgment = ?', 0).count
  end

  private
    def destroy_all
      #Problem.where(user_id: current_user.id).destroy_all
      User.find(current_user.id).problems.destroy_all
    end
end
