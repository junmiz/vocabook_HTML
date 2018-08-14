class ProblemsController < ApplicationController
  before_action :destroy_all, only: [:start]

  def show
    @prob_typ = params[:typ]
    
    @problem = current_user.problems.find(params[:id])
    @vocab_book = VocabBook.find(@problem.vocab_book_id)

    # 不正解の単語を3つ取得
    array = Array.new(4)
    VocabBook.uncached do   # クエリキャッシュOFF→order("RANDOM()")がループ二回目に一回目のキャッシュで処理されてしまうのを回避
      loop{
        # 単語をランダムに3件取得
        @vocab_books = VocabBook.order("RANDOM()").limit(3)
        
        idx = 0
        flg = false
        # 取得した単語のidを配列に保存
        @vocab_books.each do |v|
          array[idx] = v.id
          idx += 1
          if v.id == @vocab_book.id
            # 正解の単語が含まれる場合フラグを立てる
            flg = true
          end
        end
        
        if !flg 
          # 正解の単語が含まれなければループ終了
          break
        end
      }
    end
    array[3] = @vocab_book.id
    array = array.shuffle

    @vocab_books = VocabBook.find(array)
    
    # 何問目＆問題数取得
    @prob_num = current_user.problems.where('id <= ?', params[:id]).count
    @prob_cnt = current_user.problems.count
  end

  # 試験問題の初期化
  # params[:cnt] 10,20,50:10,20,50問／0：全問／-1：間違えた問題のみ
  def start
    # 試験問題の初期化 before_action
    
    problem_cnt = params[:typ]
    if params[:typ].to_i == 0       # 全問
      problem_cnt = VocabBook.count
    elsif params[:typ].to_i == -1   # 間違えた問題のみ
      problem_cnt = ChoiceQuestionStatus.where(user_id: current_user.id).where(status: 2).count
    end
    
    # 単語帳を指定件数ランダムに取得する
    if params[:typ].to_i >= 0   # 10,20,50問、全問
      vocab_books = VocabBook.order("RANDOM()").limit(problem_cnt)
    else                        # 間違えた問題のみ
      vocab_books = VocabBook.joins(:choice_question_statuses).where(choice_question_statuses: { user_id: current_user.id }).where(choice_question_statuses: { status: 1 }).order("RANDOM()")
    end

    vocab_books.each do |vocab_book|
      problem = Problem.new(user_id: current_user.id, vocab_book_id: vocab_book.id)
      if problem.save
      else
        puts "★★★error:problem.save"
      end
    end
    
    redirect_to problems_url(typ: params[:typ], id: current_user.problems.first)
  end

  def answer
    @prob_typ = params[:typ]
    
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
    choice_question_status = ChoiceQuestionStatus.find_or_create_by(user_id: current_user.id, vocab_book_id: @prob_vocabook.id)
    choice_question_status.status = @problem.judgment
    if choice_question_status.save
    else
      puts "★★★error:choice_question_status.save"
    end
    
    # 次問題id取得
    @next_problem = current_user.problems.where('id > ?', params[:prob_id]).first
  end
  
  def result
    @prob_typ = params[:typ]
    
    # 正解率取得
    @prob_cnt = current_user.problems.count
    @corr_num = current_user.problems.where('judgment = ?', 0).count
  end

  private
    def destroy_all
      User.find(current_user.id).problems.destroy_all
    end
end
