require 'spec_helper'

describe SearchController, :type => :controller do
  let(:triple) { '{"results":{"bindings":[{"s":{"value":"1_s"},"p":{"value":"1_p"},"o":{"value":"1_o"}},{"s":{"value":"1_s"},"p":{"value":"1_p"},"o":{"value":"2_o"}},{"s":{"value":"1_s"},"p":{"value":"2_p"},"o":{"value":"1_o"}}]}}' }
  let(:dict) { {'1_s' => {'1_p' => ['1_o', '2_o'], '2_p' => ['1_o']}} }

  before :each do
    stub_request(:post, CONFIG['sparql_server'] + 'select?output=json')
      .to_return(:body => triple, :status => 200)
  end

  describe 'POST fields' do
    it 'returns HTTP Success' do
      post 'fields'
      expect(response).to be_success
    end
  end

  describe 'POST fetch' do
    it 'returns HTTP Success' do
      post 'fetch'
      expect(response).to be_success
    end
  end

  describe '.get_results' do
    it 'parses the results' do
      expect(controller).to receive(:parse_results)
      controller.get_results('query')
    end
  end

  describe '.parse_results' do
    it 'should convert triples into hashes' do
      json = JSON.parse(triple)['results']['bindings']
      expect(controller.parse_results(json)).to eq(dict)
    end
  end

end
