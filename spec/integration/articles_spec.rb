require 'swagger_helper'

def article_response_schema
  {
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
  }
end

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
        schema article_response_schema
        let(:id) { create(:article).id }

        run_test!
      end

      response '404', 'article not found' do
        let(:id) { 'record_not_found' }
        run_test!
      end
    end
  end

  path '/article_url' do
    get 'retreieve article by url' do
      tags 'Articles'
      produces 'application/json'
      parameter name: :q, in: :query, type: :string, required: true

      response '200', 'found article' do
        schema article_response_schema
        let!(:url) { create(:article).url }
        let(:q) { url }

        run_test!
      end

      response '404', 'not found' do
        let(:q) { 'record_not_found' }

        run_test!
      end
    end
  end

  path '/articles' do
    get 'retrieves all articles' do
      tags 'Articles'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :'filter_ids[]', in: :query, type: :array, collectionFormat: :multi, required: false
      parameter name: :filter_title_contains, in: :query, type: :string, required: false
      parameter name: :order_by, in: :query, type: :string, required: false
      parameter name: :order_direction, in: :query, type: :string, required: false

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
        schema article_response_schema
        let(:article) { attributes_for(:article) }

        run_test!
      end
    end
  end
end
