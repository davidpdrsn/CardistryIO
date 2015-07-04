module SharingPolicy
  class Violation
    def initialize(message)
      @message = message
    end

    attr_reader :message

    def policy_violated?
      true
    end
  end
end
