class Policy
  attr_reader :rules

  def initialize(id, rules)
    @id = id
    @rules = rules
  end

  def create_policy
    to_json
  end

  def get_excluded_purpose
    # TODO: implement
  end

  def get_excluded_utilizer
    # TODO: implement
  end

  def new_rule(args)
    add_rule Rule.new(args)
  end

  def add_rule(rule)
    max_id = rules.map(&:id).max
    rule.id = max_id + 1
    rules << rule
  end

  def get_tr_rules # rename?
    # TODO: implement
  end

  def archive_rule(rule_id)
    rule = rules.select { |rule| rule.id == rule_id }.first
    rule.archive!
  end

  def update_rule(args)
    # TODO: implement
  end

  def to_json
    preferences = @rules.map { |rule| { rule: rule.to_h } }

    {
      id: @id,
      preference: preferences
    }.to_json
  end
end
