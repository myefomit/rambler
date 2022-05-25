require 'rails_helper'

RSpec.describe '/articles', type: :request do
  describe 'GET' do
    let(:path) { '/articles' }
    before(:each) { get path }
    subject { response }

    it { is_expected.to have_http_status(:success) }

    context 'when no entities' do
      it 'returns empty array' do
        expect(subject.body).to eq('[]')
      end
    end

    context 'when some entities' do
      let!(:articles) { create_list :article, 5 }
      before { get path }

      it 'returns entities' do
        expect(subject.body).to eq(articles.to_json)
      end
    end
  end

  describe 'POST' do
    let(:params) { { params: { article: article_params } } }
    before(:each) do
      post '/articles', **params
    end
    subject { response }

    context 'when correct params' do
      let(:article_params) { attributes_for(:article) }

      it { is_expected.to have_http_status(:created) }

      it 'returns new entity as response' do
        response_body =
          JSON.parse(subject.body)
              .symbolize_keys
              .except(:id, :created_at, :updated_at, :publish_date)

        expect(response_body).to eq(article_params.except(:publish_date))
      end
    end
  end
end

RSpec.describe '/articles/:id', type: :request do
  describe 'PUT' do
    let(:params) { { params: { article: article_params } } }
    let(:path) { "/articles/#{article.id}" }
    subject { response }

    before(:each) do
      put path, **params
    end

    context 'when params are correct' do
      let(:article_params) { attributes_for(:article) }

      context 'when article found' do
        let!(:article) { create(:article) }

        it { is_expected.to have_http_status(:no_content) }

        it 'updates article fields' do
          article.reload
          article_params
            .except(:publish_date)
            .each do |attr, value|
              expect(article[attr]).to eq value
            end
        end
      end

      context 'when article not found' do
        let(:path) { '/articles/there_in_no_such_article' }

        it { is_expected.to have_http_status(:not_found) }
      end
    end
  end

  describe 'DELETE' do
    let(:path) { "/articles/#{article.id}" }
    subject { response }

    before(:each) { delete path }

    context 'when article found' do
      let!(:article) { create(:article) }

      it { is_expected.to have_http_status(:no_content) }
    end

    context 'when article not found' do
      let(:path) { '/articles/there_in_no_such_article' }

      it { is_expected.to have_http_status(:not_found) }
    end
  end
end
