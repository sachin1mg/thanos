module StateTransitions
  module MaterialRequest
    extend ::ActiveSupport::Concern

    included do
      include AASM

      aasm column: 'status' do
        state :created, initial: true
        state :pending
        state :ordered
        state :partially_ordered
        state :cancelled
        state :closed

        event :cancel do
          transitions from: :created, to: :cancelled
        end

        event :mark_pending do
          transitions from: :created, to: :pending
        end

        event :close do
          transitions from: %i(created pending), to: :closed
        end
      end
    end
  end
end
