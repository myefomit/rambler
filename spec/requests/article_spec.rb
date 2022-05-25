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
      post '/articles', params
    end
    subject { response }

    context 'when correct params' do
      let(:article_params) { attributes_for(:article) }

      it { is_expected.to have_http_status(:created) }
    end
  end
end
