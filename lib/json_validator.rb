require 'json-schema'

class JsonValidator
  def self.validate(schema_name, data)
    name = "../schemas/#{schema_name}.json"
    schema = File.expand_path(name, __FILE__)
    JSON::Validator.validate(schema, data)
  end
end
