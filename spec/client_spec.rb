require 'jsonapi/client'

describe JSONAPI::Client, '' do
  it 'works' do
    client = JSONAPI::Client.new(base_url: 'http://api.example.com')

    client[:users]
      .include(posts: [:author, comments: [:author]])
      .fields(posts: [:title, :content], users: [:name, :email])
      .params(page: 3)
      .list
  end
end
