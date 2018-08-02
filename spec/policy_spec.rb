require 'spec_helper'
require 'policy'
require 'rule'

RSpec.describe Policy do
  describe '#archive_rule' do
    it 'calls #archive! on appropriate rule' do
      rule_number_one = Rule.new(id: 1)
      rules = [
        Rule.new(id: 0),
        rule_number_one,
        Rule.new(id: 2)
      ]

      policy = Policy.new(rules)

      expect(rule_number_one).to receive(:archive!)
      policy.archive_rule(1)
    end
  end
end
