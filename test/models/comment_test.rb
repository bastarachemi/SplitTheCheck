require "test_helper"

class CommentTest < ActiveSupport::TestCase

  test "comment attributes must not be empty" do
    comment = Comment.new
    assert comment.invalid?
    assert comment.errors[:message].any?
  end

end
