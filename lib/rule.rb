class Rule
  attr_reader :id, :permitted_purposes, :excluded_purposes,
    :permitted_utilizers, :excluded_utilizers, :transformations, :valid_from,
    :expiration_date

  def initialize(args)
    args.each do |key, value|
      self.instance_variable_set("@#{key}".to_sym, value)
    end
  end

  def archive!
    @id = -1
    @expiration_date = Time.now
  end

  def to_json
    # TODO: implement
  end
end
