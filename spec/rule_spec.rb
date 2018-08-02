require 'spec_helper'
require 'rule'

RSpec.describe Rule do
  describe '#archive!' do
    it 'sets expiration_date to now and id to -1' do
      set_time = Time.now - 100_000_000
      rule = Rule.new(id: 100, expiration_date: set_time)

      rule.archive!

      expect(rule.id).to eq -1
      expect(rule.expiration_date).to be > set_time
    end
  end
end
