require 'swagger_helper'

describe 'ArticleTags API' do
  path '/article_tags/{id}' do
    delete 'deletes article_tags' do
      tags 'ArticleTags'
      parameter name: :id, in: :path, type: :string

      response '204', 'deleted' do
        let(:id) { create(:article_tag).id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 'record_not_found' }
        run_test!
      end
    end
  end

  path '/article_tags' do
    get 'retrieves all article_tags' do
      tags 'ArticleTags'
      produces 'application/json'

      response '200', 'lists article_tags' do
        run_test!
      end
    end

    post 'creates new article_tag' do
      tags 'ArticleTags'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :article_tag, in: :body, schema: {
        type: :object,
        properties: {
          article_id: { type: :integer },
          tag_id: { type: :integer }
        },
        required: true
      }

      response '201', 'article_tag created' do
        schema({
          type: :object,
          properties: {
            id: { type: :integer },
            article_id: { type: :integer },
            tag_id: { type: :integer }
          }
        })
        let!(:article) { create(:article) }
        let!(:tag) { create(:tag) }
        let(:article_tag) { {article_id: article.id, tag_id: tag.id } }

        run_test!
      end

      response '422', 'cannot process article_tag' do
        let(:article_tag) { { article_id: 0, tag_id: 0 } }

        run_test!
      end
    end
  end
end
