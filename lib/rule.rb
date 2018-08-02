class Rule
  attr_reader :permitted_purposes, :excluded_purposes, :permitted_utilizers,
    :excluded_utilizers, :transformations, :valid_from, :expiration_date

  def to_json
    # TODO: implement
  end
end
