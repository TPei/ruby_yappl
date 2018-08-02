require 'spec_helper'
require 'json_validator'

RSpec.describe JsonValidator do
  describe '.validate' do
    it 'returns true for valid schema + file' do
      json = File.expand_path('../schemas/valid_schema.json', __FILE__)
      expect(JsonValidator.validate('yappl', json)).to eq true
    end

    it 'returns false for invalid schema' do
      json = File.expand_path('../schemas/invalid_schema.json', __FILE__)
      expect(JsonValidator.validate('yappl', json)).to eq false
    end

    it 'returns false for broken json' do
      json = File.expand_path('../schemas/broken_schema.json', __FILE__)
      expect(JsonValidator.validate('yappl', json)).to eq false
    end

    it 'fails with non-existent schema file' do
      expect { JsonValidator.validate('bla', {}) }.
        to raise_error(JSON::Schema::ReadFailed)
    end
  end
end
