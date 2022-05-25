require 'rails_helper'

RSpec.describe '/articles', type: :request do
  describe 'GET' do
    let(:path) { '/articles' }
    before(:each) { get path }
    subject { response }

    it { is_expected.to have_http_status(200) }

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
    before(:each) { post '/articles', params }
  end
end
