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

  describe '#to_json' do
    it 'serializes appropriately' do
      time = Time.now

      rule = Rule.new(
        id: 1,
        permitted_purposes: ['test1', 'test2'],
        excluded_purposes: ['test3'],
        permitted_utilizers: ['util1'],
        excluded_utilizers: ['util2', 'util3'],
        transformations: [{
          attribute: 'temperature',
          tr_func: 'minmax_hourly'
        }],
        valid_from: time,
        expiration_date: time
      )

      expect(rule.to_json).to eq({
        purpose: {
          permitted: ['test1', 'test2'],
          excluded: ['test3'],
        },
        utilizer: {
          permitted: ['util1'],
          excluded: ['util2', 'util3'],
        },
        transformation: [{
          attribute: 'temperature',
          tr_func: 'minmax_hourly'
        }],
        valid_from: time.strftime('%FT%T.%LZ'),
        exp_date: time.strftime('%FT%T.%LZ')
      }.to_json)
    end
  end
end
