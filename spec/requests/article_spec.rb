require 'rails_helper'

RSpec.describe '/articles', type: :request do
  let(:path) { '/articles' }
  subject { response }

  describe 'GET' do
    before(:each) { get path }

    it { is_expected.to have_http_status(:success) }

    context 'when no entities' do
      it 'returns empty array' do
        expect(subject.body).to eq('[]')
      end
    end

    context 'when some entities' do
      let!(:articles) { create_list :article, 5 }
      let(:query) { {} }
      let(:params) { { params: query } }
      let(:parsed_body) { JSON.parse(subject.body) }
      before { get path, **params }

      it 'returns entities' do
        expect(subject.body).to eq(articles.to_json)
      end

      context 'when filter_tag_ids' do
        let!(:article) { create(:article) }
        let!(:tag) { create(:tag) }
        let!(:article_tag) { create :article_tag, article_id: article.id, tag_id: tag.id }
        let(:query) { { filter_tag_ids: [tag.id] } }

        before { get path, **params }

        it 'returns correct article' do
          expect(Article.count).to eq(6)
          expect(parsed_body.count).to eq(1)
          expect(parsed_body.first['id']).to eq(article.id)
        end
      end

      context 'when ids filter' do
        let!(:id) { create(:article).id }
        let(:query) { { filter_ids: [id] } }

        it 'returns correct article' do
          expect(Article.count).to eq(6)
          expect(parsed_body.count).to eq(1)
          expect(parsed_body.first['id']).to eq(id)
        end
      end

      context 'when title_contains filter' do
        let!(:article) { create(:article, title: 'un1qu3 t1tl3') }
        let(:query) { { filter_title_contains: article.title[1, 5] } }

        it 'returns correct article' do
          expect(Article.count).to eq(6)
          expect(parsed_body.count).to eq(1)
          expect(parsed_body.first['title']).to eq(article.title)
        end
      end

      context 'when ordered by id desc' do
        let(:query) { { order_by: 'id', order_direction: 'desc' } }

        it 'returns articles in correct order (desc)' do
          expect(Article.count).to eq(5)
          expect(parsed_body.map { |h| h['id'] }).to eq(Article.order(id: :desc).pluck(:id))
        end
      end
    end
  end

  describe 'POST' do
    let(:params) { { params: { article: article_params } } }

    before(:each) do
      post path, **params
    end

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
  let(:not_found_path) { '/articles/there_is_no_such_article' }
  let(:path) { "/articles/#{article.id}" }
  subject { response }

  describe 'PUT' do
    let(:params) { { params: { article: article_params } } }

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
        let(:path) { not_found_path }

        it { is_expected.to have_http_status(:not_found) }
      end
    end
  end

  describe 'DELETE' do
    before(:each) { delete path }

    context 'when article found' do
      let!(:article) { create(:article) }

      it { is_expected.to have_http_status(:no_content) }

      it 'deletes article' do
        expect { Article.find(article.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when article not found' do
      let(:path) { not_found_path }

      it { is_expected.to have_http_status(:not_found) }
    end
  end

  describe 'GET' do
    before(:each) { get path }

    context 'when article found' do
      let!(:article) { create(:article) }

      it { is_expected.to have_http_status(:ok) }

      it 'returns article json' do
        expect(subject.body).to eq(article.to_json)
      end
    end

    context 'when article not found' do
      let(:path) { not_found_path }

      it { is_expected.to have_http_status(:not_found) }
    end
  end
end

RSpec.describe '/article_url', type: :request do
  let(:path) { '/article_url' }
  let(:params) { { params: { q: query } } }
  subject { response }

  before(:each) { get path, **params }

  context 'when article not found' do
    let(:query) { 'record_not_found' }

    it { is_expected.to have_http_status(:not_found) }
  end

  context 'when article found' do
    let!(:article) { create(:article) }
    let(:query) { article.url }

    it { is_expected.to have_http_status(:ok) }

    it 'returns correct article' do
      parsed_body = JSON.parse(subject.body)

      expect(parsed_body['id']).to eq(article.id)
    end
  end
end
