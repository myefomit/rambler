require 'swagger_helper'

describe 'Articles API ' do
  path '/articles/{id}' do
    put 'updates article' do
      tags 'Articles'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
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

      response '204', 'updated' do
        let(:id) { create(:article).id }
        let(:article) { attributes_for(:article) }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 'record_not_found' }
        let(:article) { attributes_for(:article) }
        run_test!
      end
    end

    delete 'deletes article' do
      tags 'Articles'
      parameter name: :id, in: :path, type: :string

      response '204', 'deleted' do
        let(:id) { create(:article).id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 'record_not_found' }
        run_test!
      end
    end

    get 'retrieves specific article' do
      tags 'Articles'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'article found' do
        schema(
          type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            abstract: { type: :string },
            content: { type: :string },
            url: { type: :string },
            image_url: { type: :string },
            publish_date: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string }
          }
        )
        let(:id) { create(:article).id }

        run_test!
      end

      response '404', 'article not found' do
        let(:id) { 'record_not_found' }
        run_test!
      end
    end
  end

  path '/articles' do
    get 'retrieves all articles' do
      tags 'Articles'
      produces 'application/json'

      response '200', 'lists articles' do
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
        let(:article) { attributes_for(:article) }

        run_test!
      end
    end
  end
end


