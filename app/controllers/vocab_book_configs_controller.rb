class VocabBookConfigsController < ApplicationController
  before_action :set_vocab_book_config, only: [:update]

  def update
    @vocab_book_config.user_id = current_user.id
    @vocab_book_config.filter = params[:filter]
    if @vocab_book_config.save
    else
       puts "★★★error:vocab_book_config"
    end

    redirect_to controller: 'vocabook', action: :show, show_id: "last"
  end
  
  private
    def set_vocab_book_config
      @vocab_book_config = VocabBookConfig.find_or_create_by(user_id: current_user.id)
    end
end
