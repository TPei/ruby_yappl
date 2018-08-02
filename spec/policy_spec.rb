require 'spec_helper'
require 'policy'
require 'rule'
require 'json_validator'

RSpec.describe Policy do
  describe '#archive_rule' do
    it 'calls #archive! on appropriate rule' do
      rule_number_one = Rule.new(id: 1)
      rules = [
        Rule.new(id: 0),
        rule_number_one,
        Rule.new(id: 2)
      ]

      policy = Policy.new(1, rules)

      expect(rule_number_one).to receive(:archive!)
      policy.archive_rule(1)
    end
  end

  describe '#create_policy' do
    it 'calls #to_json' do
      policy = Policy.new(1, [])
      expect(policy).to receive(:to_json)
      policy.create_policy
    end
  end

  describe '#to_json' do
    before do
      @rule = Rule.new(
        id: 1,
        permitted_purposes: ['test1', 'test2'],
        excluded_purposes: ['test3'],
        permitted_utilizers: ['util1'],
        excluded_utilizers: ['util2', 'util3'],
        transformations: [],
        valid_from: Time.now,
        expiration_date: Time.now
      )

      @policy = Policy.new(1, [@rule])
    end

    it 'serializes appropriately' do
      expect(@policy.to_json).to eq ({
        id: 1,
        preference: [{ rule: @rule.to_h }]
      }.to_json)
    end

    it 'generated valid schema json' do
      serialized = @policy.to_json
      puts serialized
      expect(JsonValidator.validate('yappl', serialized)).to eq true
    end
  end
end
