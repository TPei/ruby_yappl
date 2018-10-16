require 'policy'
require 'rule'
require 'exceptions'
require 'json'

module YaPPL
  class Parser
    def self.parse(json)
      raise SchemaError unless JsonValidator.validate('yappl', json)

      data = JSON.parse(json)
      rules = data['preference'].collect do |preference|
        rule = preference['rule']
        Rule.new(
          permitted_purposes: rule['purpose']['permitted'],
          excluded_purposes: rule['purpose']['excluded'],
          permitted_utilizers: rule['utilizer']['permitted'],
          excluded_utilizers: rule['utilizer']['excluded'],
          transformations: rule['transformation'],
          valid_from: Time.parse(rule['valid_from']),
          expiration_date: Time.parse(rule['exp_date'])
        )
      end
      return Policy.new(data['id'], rules)
    end
  end
end
