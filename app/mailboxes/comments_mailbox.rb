class CommentsMailbox < ApplicationMailbox
  before_processing :validate_request #((1))

  def process #((2))
    board.comments.create!(body: mail.decoded, creator: commenter)
  end

  # リクエストのバリデーション
  def validate_request
    return if commenter && board

    bounce_with CommentMailer.invalid_request( #((3))
      inbound_email, commenter: commenter, board: board
    )
  end

  # コメント投稿者となるUserオブジェクトを取得
  def commenter
    return @commenter if defined?(@commenter)
    @commenter = User.find_by(email: mail.from) #((4))
  end

  # 書き込み先Boardオブジェクトを取得
  def board
    return @board if defined?(@board)
    @board = Board.find_by(id: mail.to.split('-')[0]) #((5))
  end
end
