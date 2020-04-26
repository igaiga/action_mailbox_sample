require "test_helper"

class CommentsMailboxTest < ActionMailbox::TestCase
  test 'メールの本文が、対応するBoardのコメントとして正しく追加されること' do
    assert_difference -> { boards(:sample).comments.count } do
      receive_inbound_email_from_mail \
        to: "#{boards(:sample).id}-comment@example.com",
        from: users(:willnet).email,
        subject: 'メールタイトル',
        body: 'こんにちは!'
    end
    comment = boards(:sample).comments.last
    assert_equal users(:willnet), comment.creator
    assert_equal 'こんにちは!', comment.body
  end
end
