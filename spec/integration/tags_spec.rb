require 'swagger_helper'

describe 'Tags API' do
  path '/tags/{id}' do
    delete 'deletes tag' do
      tags 'Tags'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '204', 'deleted' do
        let(:id) { create(:tag).id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 'record_not_found' }
        run_test!
      end
    end

    put 'updates tag' do
      tags 'Tags'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :tag, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          slug: { type: :string }
        },
        required: true
      }

      response '204', 'updated' do
        let(:id) { create(:tag).id }
        let(:tag) { attributes_for(:tag) }

        run_test!
      end

      response '404', 'not found' do
        let(:id) { 'record_not_found' }
        let(:tag) { attributes_for(:tag) }

        run_test!
      end
    end
  end

  path '/tags' do
    get 'retreieves all tags' do
      tags 'Tags'
      produces 'application/json'
      parameter name: :page, in: :query, type: :string, required: false

      response '200', 'lists tags' do
        run_test!
      end
    end

    post 'creates new tag' do
      tags 'Tags'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :tag, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          slug: { type: :string }
        },
        required: true
      }

      response '201', 'tag created' do
        schema({
          type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            slug: { type: :string }
          }
        })
        let(:tag) { attributes_for(:tag) }

        run_test!
      end
    end
  end
end
