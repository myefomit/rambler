require 'swagger_helper'

describe 'Articles API ' do

  path '/articles' do

    get 'retrieves all articles' do
      tags 'Articles'
      produces 'application/json'

      response '200', 'list of articles' do
        run_test!
      end
    end

    post 'creates an article' do
      tags 'Articles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :article, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          abstract: { type: :string },
          content: { type: :string },
          url: { type: :string },
          image_url: { type: :string },
          publish_date: { type: :string }
        },
        required: true
      }

      response '201', 'article created' do
        let(:article) do
          {
            title: 'Example',
            url: 'https://example.com/articles/example',
            publish_date: '2022-05-24T14:49:29+05:00',
            image_url: 'https://example.com/articles/example_image',
            abstract: 'Example article',
            content: 'Example article loooooooooong text'
          }
        end

        run_test!
      end
    end
  end
end


