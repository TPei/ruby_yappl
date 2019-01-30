require 'spec_helper'
require 'rule'

RSpec.describe YaPPL::Rule do
  describe '#initialize' do
    it 'sets all given attributes' do
      time = Time.now

      args = {
        id: 1, permitted_purposes: ['p1'], excluded_purposes: ['p2'],
        permitted_utilizers: ['u1'], excluded_utilizers: ['u2'],
        transformations: [{
          attribute: 'temperature',
          tr_func: 'minmax_hourly'
        }],
        valid_from: time,
        expiration_date: time
      }

      rule = YaPPL::Rule.new(args)
      expect(rule.id).to eq 1
      expect(rule.permitted_purposes).to eq ['p1']
      expect(rule.excluded_purposes).to eq ['p2']
      expect(rule.permitted_utilizers).to eq ['u1']
      expect(rule.excluded_utilizers).to eq ['u2']
      expect(rule.transformations).to eq [{
        attribute: 'temperature',
        tr_func: 'minmax_hourly'
      }]
      expect(rule.valid_from).to eq time
      expect(rule.expiration_date).to eq time
    end

    context 'with no valid_from and expiration_date provided' do
      it 'sets defaults values' do
        rule = YaPPL::Rule.new
        expect(rule.valid_from).not_to eq nil
        expect(rule.expiration_date).to eq Time.utc(0, 1, 1)
      end
    end
  end

  describe '#archive!' do
    it 'sets expiration_date to now and id to -1' do
      set_time = Time.now - 100_000_000
      rule = YaPPL::Rule.new(id: 100, expiration_date: set_time)

      rule.archive!

      expect(rule.id).to eq -1
      expect(rule.expiration_date).to be > set_time
    end
  end

  describe '#to_h' do
    it 'serializes appropriately' do
      time = Time.now

      rule = YaPPL::Rule.new(
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

      expect(rule.to_h).to eq({
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
      })
    end
  end

  describe '#expired?' do
    context 'with expiration_date set to default' do
      it 'returns false' do
        rule = YaPPL::Rule.new
        expect(rule.expired?).to eq false
      end
    end

    context 'with expiration_date set in past' do
      it 'returns true' do
        rule = YaPPL::Rule.new(expiration_date: Time.new(2000, 1, 1))
        expect(rule.expired?).to eq true
      end
    end

    context 'with expiration_date set in future' do
      it 'returns false' do
        # have fun with this in a thousand years :D
        rule = YaPPL::Rule.new(expiration_date: Time.new(3000, 1, 1))
        expect(rule.expired?).to eq false
      end
    end
  end
end
