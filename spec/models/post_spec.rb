require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) do
    User.create(name: 'ahmed', photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                bio: 'A genius Backend developer from Egypt.')
  end

  before do
    user
  end

  describe 'validations' do
    it 'should validate presence of title' do
      post = Post.new(title: nil, author: user)
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it 'should validate maximum length of title' do
      post = Post.new(author: user, title: 'a' * 251, liked_counter: 5, comments_counter: 4)
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include('is too long (maximum is 250 characters)')

      post.title = 'a' * 250
      expect(post).to be_valid
    end

    it 'should validate numericality of comments_counter' do
      post = Post.new(author: user, title: 'Sample Title', liked_counter: 5, comments_counter: -1)
      expect(post).not_to be_valid
      expect(post.errors[:comments_counter]).to include('must be greater than or equal to 0')

      post.comments_counter = 10
      expect(post).to be_valid
    end

    it 'should validate numericality of liked_counter' do
      post = Post.new(author: user, title: 'Sample Title', comments_counter: 0, liked_counter: -1)
      expect(post).not_to be_valid
      expect(post.errors[:liked_counter]).to include('must be greater than or equal to 0')

      post.liked_counter = 5
      expect(post).to be_valid
    end
  end
end

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, class_name: 'User', foreign_key: :author_id

  after_save :update_post_comments_counter
  after_destroy :update_post_comments_counter

  private

  def update_post_comments_counter
    post.update(comments_counter: post.comments.count)
  end
end

RSpec.describe 'update_user_posts_counter' do
  it "should set the user's posts_counter to 0 initially" do
    user = User.create(name: 'John Doe', posts_counter: 0)
    expect(user.posts_counter).to eq(0)
  end
end
