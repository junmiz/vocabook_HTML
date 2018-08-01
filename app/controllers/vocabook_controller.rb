class VocabookController < ApplicationController
  before_action :set_vocab_book, only: [:update]
  before_action :set_learning_status, only: [:update]

  def show
    # 設定情報を取得
    # ★userモデル生成時に自動で設定モデルも生成しておきたい
    @vocab_book_config = VocabBookConfig.find_or_create_by(user_id: current_user.id)
    
    # 基本のidを取得
    if params[:show_id] == "first"      # 始めから
      # 先頭の単語帳を取得
      @vocab_book = VocabBook.first
    elsif params[:show_id] == "last"    # 続きから
      # 前回終了時の単語帳の次を取得
      @last_learning = LastLearning.find_or_create_by(user_id: current_user.id)

      if @last_learning.vocab_book_id.nil?
        @vocab_book = VocabBook.first
      else
        @vocab_book = VocabBook.find(@last_learning.vocab_book_id)
      end
    elsif params[:show_id] == "next"    # 次の単語s
      # 現在表示中の単語帳の次を取得
      @vocab_book = VocabBook.where('id > ?', params[:id]).first
      if @vocab_book.nil?   # 取得できない→最後の単語帳終了
        # 先頭の単語帳を取得
        @vocab_book = VocabBook.first
      end
    end

    if @vocab_book_config.filter == 1  # 未習得のみ
      loop{
        set_learning_status
        if @learning_status.nil?      # 習得状況が存在しない→未習得
          break
        end
        
        if !(@learning_status.status == 1)  # 未習得
          break
        end
        
        # 次の単語帳を取得
        @vocab_book = VocabBook.where('id > ?', @vocab_book.id).first
        if @vocab_book.nil?
          # ★最後のidに達したら、全て習得済みのメッセージを表示   したいが、仮で先頭を返す
          @vocab_book = VocabBook.first
          break
        end
      }      
    end
    
    # 習得件数の取得
    @learn_cnt = current_user.learning_statuses.where(status: 1).count
    @vocabook_total_cnt = VocabBook.count
    
    # 前回終了単語の更新
    @last_learning = LastLearning.find_or_create_by(user_id: current_user.id)
    @last_learning.user_id = current_user.id
    @last_learning.vocab_book_id = @vocab_book.id
    if @last_learning.save
    else
      puts "★★★error:last_learning.save"
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
end
