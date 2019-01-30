module YaPPL
  class Rule
    attr_accessor :id
    attr_reader :permitted_purposes, :excluded_purposes, :permitted_utilizers,
      :excluded_utilizers, :transformations, :valid_from, :expiration_date

    def initialize(args = {})
      args.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
      @valid_from = Time.now unless valid_from
      @expiration_date = default_time unless expiration_date
    end

    def archive!
      @id = -1
      @expiration_date = Time.now
    end

    def expired?
      expiration_date != default_time && Time.now > expiration_date
    end

    def to_h
      {
        purpose: {
          permitted: permitted_purposes,
          excluded: excluded_purposes
        },
        utilizer: {
          permitted: permitted_utilizers,
          excluded: excluded_utilizers
        },
        transformation: transformations,
        valid_from: valid_from.strftime('%FT%T.%LZ'),
        exp_date: expiration_date.strftime('%FT%T.%LZ')
      }
    end

    private

    def default_time
      Time.utc(0, 1, 1)
    end
  end
end
