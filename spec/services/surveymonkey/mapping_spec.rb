require 'rails_helper'

include Surveymonkey

RSpec.describe Mapping do
  describe '.path_by_name' do
    it 'returns absolute path to json file' do
      expect(Mapping.path_by_name('mailchimp')).to include('app/services/surveymonkey/schemes/mailchimp.json')
    end
  end

  describe '.from_json' do
    it 'returns an instance with Scheme array' do
      mapping = Mapping.from_json('[{"name":"email","page_id":"123","question_id":"456","type":"text"}]')
      expect(mapping.schemes.first).to be_a(Mapping::Scheme)
    end
  end

  describe '.find_by' do
    before :each do
      Mapping.send(:remove_const, 'CACHE')
      Mapping::CACHE = {}
    end

    it 'returns cached value if exists' do
      expect(Mapping.find_by(name: 'webhook')).to be(nil)

      cached_mapping = Mapping.new({})
      Mapping::CACHE['webhook'] = cached_mapping
      expect(Mapping.find_by(name: 'webhook')).to be(cached_mapping)
    end

    it 'returns nil if json does not exist' do
      expect(Mapping.find_by(name: 'not_exists')).to be(nil)
      expect(Mapping.find_by(name: 'mailchimp')).not_to be(nil)
    end

    it 'returns new instance with schemes' do
      mapping = Mapping.find_by(name: 'mailchimp')
      expect(mapping.schemes.first).to be_a(Mapping::Scheme)
    end

    it 'caches mapping as soon as it found' do
      expect(Mapping::CACHE).to eq({})
      mapping = Mapping.find_by(name: 'mailchimp')
      expect(Mapping::CACHE['mailchimp']).to be(mapping)
      expect(Mapping.find_by(name: 'mailchimp')).to be(mapping)
    end
  end
end