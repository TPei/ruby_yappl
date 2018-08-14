module YaPPL
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
      rules.map(&:excluded_purposes).flatten.uniq
    end

    def get_excluded_utilizer
      rules.map(&:excluded_utilizers).flatten.uniq
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
      active_rules.map do |rule|
        {
          permitted_purposes: rule.permitted_purposes,
          permitted_utilizers: rule.permitted_utilizers,
          transformations: rule.transformations
        }
      end
    end

    def archive_rule(rule_id)
      rule = rule_by_id(rule_id)
      rule.archive!
    end

    def update_rule(id, args)
      archive_rule(id)
      rule = Rule.new(args)
      rule.id = id
      rules << rule
    end

    def to_json
      preferences = @rules.map { |rule| { rule: rule.to_h } }

      {
        id: @id,
        preference: preferences
      }.to_json
    end

    def rule_by_id(id)
      matching_rules = rules.select { |rule| rule.id == id }
      if matching_rules.count == 1
        matching_rules.first
      else
        matching_rules
      end
    end

    def archived_rules
      rules.select { |rule| rule.id == -1 }
    end

    def active_rules
      rules.select { |rule| rule.id != -1 && !rule.expired? }
    end
  end
end
