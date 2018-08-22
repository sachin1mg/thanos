module StateTransitions
  module MaterialRequest
    extend ::ActiveSupport::Concern

    included do
      include AASM

      aasm column: 'status' do
        state :created, initial: true
        state :downloaded
        state :ordered
        state :partially_ordered
        state :cancelled
        state :closed

        event :cancel do
          transitions from: :created, to: :cancelled
        end

        event :download do
          transitions from: :created, to: :downloaded
        end

        event :close do
          transitions from: %i(created downloaded), to: :closed
        end
      end
    end
  end
end
