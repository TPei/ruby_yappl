require 'spec_helper'
require 'parser'

RSpec.describe YaPPL::Parser do
  describe '.parse' do
    context 'with valid schema' do
      it 'returns a policy' do
        policy = YaPPL::Parser.parse(File.read('./spec/schemas/valid_schema.json'))
        expect(policy.class).to eq YaPPL::Policy
      end

      it 'creates a proper Policy from json' do
        policy = YaPPL::Parser.parse(File.read('./spec/schemas/valid_schema.json'))
        expect(policy.id).to eq 4493
        expect(policy.rules.count).to eq 1
      end

      it 'creates proper rules' do
        policy = YaPPL::Parser.parse(File.read('./spec/schemas/valid_schema.json'))
        expect(policy.rules.count).to eq 1
        rule = policy.rules[0]
        expect(rule.class).to eq YaPPL::Rule
        expect(rule.permitted_purposes). to eq ['statistics', 'planology']
        expect(rule.excluded_purposes).to eq ['commercial']
        expect(rule.permitted_utilizers).to eq ['wikimedia', 'tu berlin']
        expect(rule.excluded_utilizers).to eq ['netatmo', 'gate5']
        expect(rule.transformations.count).to eq 1
        expect(rule.transformations[0]['attribute']). to eq 'temperature'
        expect(rule.transformations[0]['tr_func']). to eq 'minmax_hourly'
        expect(rule.valid_from).to eq Time.parse('2017-10-09T00:00:00.000Z')
        expect(rule.expiration_date).to eq Time.parse('0000-01-01T00:00:00.000Z')
      end
    end

    context 'with invalid schema' do
      it 'raises a SchemaError' do
        expect do
          YaPPL::Parser.parse(File.read('./spec/schemas/invalid_schema.json'))
        end.to raise_error SchemaError
      end
    end

    context 'with broken schema' do
      it 'raises a SchemaError' do
        expect do
          YaPPL::Parser.parse(File.read('./spec/schemas/broken_schema.json'))
        end.to raise_error SchemaError
      end
    end
  end
end
